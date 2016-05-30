# == Schema Information
#
# Table name: orders
#
#  id                    :integer          not null, primary key
#  delivery_time         :datetime
#  state                 :string(255)
#  pay_type              :string(255)
#  address_id            :integer
#  user_id               :integer
#  created_at            :datetime
#  updated_at            :datetime
#  category              :string(255)
#  delivery_executive_id :integer
#  dispatched_at         :datetime
#  delivered_at          :datetime
#  feedback_asked        :boolean          default(FALSE)
#  delivery_fee          :float            default(0.0)
#

class Order < ActiveRecord::Base

  include AASM

  has_many :line_items
  belongs_to :address
  belongs_to :user
  counter_culture :user
  has_one :profile,through: :user
  belongs_to :delivery_executive
  has_one :debit

  DELIVERY_FEE = 10
  MIN_TOTAL_FOR_FREE_DELIVERY = 600

  validates_presence_of :address_id, :user_id, :delivery_time, :category
  validates_presence_of :category, in: MenuProduct::CATEGORIES


  aasm column: 'state' do

    state :new, initial: true
    state :pending
    state :acknowledged
    state :informed_delivery_guy
    state :dispatched
    state :delivered
    state :cancelled

    event :start_process,after: [:notify_success,:update_stock],before:[:auto_debit_amount] do
      transitions from: :new, to: :pending
    end

    event :acknowledge do
      transitions from: [:pending], to: :acknowledged
    end

    event :mark_informed do
      transitions from: [:informed_delivery_guy,:acknowledged], to: :informed_delivery_guy
    end

    event :withdraw_delivery_request,after: [:notify_withdraw_request] do
      transitions from: [:informed_delivery_guy], to: :acknowledged
    end

    event :reject_delivery_request,after: [:notify_reject_delivery_request] do
      transitions from: [:informed_delivery_guy], to: :acknowledged
    end

    event :mark_dispatched,before: [:record_dispatch_time] do
      transitions from: [:informed_delivery_guy], to: :dispatched
    end

    event :dispatch,before: [:record_dispatch_time],after:[:notify_dispatch] do
      transitions from: [:acknowledged,:dispatched], to: :dispatched
    end

    event :deliver,before:[:record_delivered_time],after: [:apply_cashback_promotions] do
      transitions from: :dispatched,to: :delivered
    end

    event :cancel,after: [:notify_cancel,:refund_prepaid_amount] do
      transitions from: [:pending,:acknowledged,:informed_delivery_guy,:dispatched], to: :cancelled
    end

  end

  alias_method :start_process, :start_process!
  alias_method :acknowledge, :acknowledge!
  alias_method :dispatch, :dispatch!
  alias_method :deliver, :deliver!
  alias_method :cancel, :cancel!

  scope :pending,-> {where(state: 'pending')}
  scope :acknowledged,-> {where(state: 'acknowledged')}
  scope :delivered,-> {where(state: 'delivered')}
  scope :today, -> {where("delivery_time >= ? and delivery_time <= ?",Time.now.beginning_of_day,
                          Time.now.end_of_day)}
  scope :lunch, -> {where(category: 'lunch')}
  scope :dinner, -> {where(category: 'dinner')}


  def self.acknowledged_or_informed_delivery_guy
    where(state: ['acknowledged','informed_delivery_guy'])
  end

  def auto_debit_amount
    user.wallet.debit_amount_for_order self
  end

  def refund_prepaid_amount
    user.wallet.refund_cancelled_order self
  end

  def cash_to_pay
    prepaid_amount > 0 ?  (grand_total - prepaid_amount) : grand_total
  end

  def self.total_cash_to_pay orders
    orders.inject(0) {|sum,o| sum + o.cash_to_pay}
  end

  def prepaid_amount
    debit.try(:amount).to_f
  end

  def notify_success
    notify_kitchen 'success'
    notify_user 'success'
  end

  def notify_cancel
    notify_kitchen 'cancel'
    notify_user 'cancel'
    notify_delivery_executive 'cancel' if delivery_executive
  end

  def update_stock
    # line_items.each{|li| }
  end

  def notify_kitchen event
    if event=='success'
      Pusher['orders'].trigger('purchased', {
        message: 'New Order Created..Refresh your browser to see it'
      })
    elsif event=='cancel'
      #TODO notify kitchen of order cancel
      Pusher['orders'].trigger('cancelled', {
        message: "Order no. #{self.id} has been cancelled. Please notify the Chef. "
      })
    elsif event=='reject_delivery_request'
      #TODO notify kitchen of delivery request rejected
      message = "#{delivery_executive.name} has rejected this order. #{user.name[0..10]},#{user.profile.phone_number}
      #{address.formatted}. ##{id}: #{sms_formatted_delivery_time}"
      Pusher['orders'].trigger('rejected_delivery_request', {
        info: message
      })
    end
  rescue Exception => e
    HealthyLunchUtils.log_error e.message,e
  end
  # Lower numbers have higher priority
  handle_asynchronously :notify_kitchen,queue: 'kitchen_notifications',priority: 5

  def notify_user event
    if event=='success'
      UserMailer.order_success(self).deliver
      UserMessenger.order_success(self)
    elsif event=='cancel'
      #TODO Notify user of order cancel
    end
  rescue Exception => e
    HealthyLunchUtils.log_error e.message,e
  end
  handle_asynchronously :notify_user,queue: 'user_notifications'

  def notify_delivery_executive event
    if event=='dispatch'
      DeliveryExecutiveMessenger.dispatch(self,sms_form)
    elsif( (event=='withdraw_delivery_request') || (event == 'cancel'))
      DeliveryExecutiveMessenger.withdraw_delivery_request(self)
    end
  end

  def sms_form
    message = "#{user.name[0..10]},#{user.profile.phone_number}
    #{address.formatted}.
##{id}: #{sms_formatted_delivery_time}
    #{brief_line_items}
Rs #{cash_to_pay.to_i}"
    message
  end

  def notify_dispatch
    notify_delivery_executive 'dispatch'
  rescue Exception => e
    HealthyLunchUtils.log_error e.message,e
  end
  handle_asynchronously :notify_dispatch,queue: 'kitchen_notifications',priority: 5

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      #cart id being set to nil for each line item thereby disasociating it from the cart
      #The same line items are being assigned to an order
      item.cart_id = nil
      line_items << item
    end
    category = cart.category
  end

  def total_price
    total = 0
    line_items.each do |li|
      total = total + li.price*li.quantity
    end
    total
  end

  def grand_total
    total_price + delivery_fee.to_i
  end

  def is_first?
    user.orders.delivered.order(:created_at).first == self 
  end

  def apply_cashback_promotions
    if is_first?
      referral = user.referred
      referral.apply_referrer_promotions if referral
    end
  rescue Exception => e
    HealthyLunchUtils.log_error e.message,e
  end

  handle_asynchronously :apply_cashback_promotions #,:run_at => Proc.new { 24.hours.from_now }

  def serializable_hash(options={})
    options ||={}
    options[:except] ||= [:user_id,:updated_at,:delivery_executive_id,:address_id]
    options[:methods] = [:cash_to_pay,:prepaid_amount,:total_price,:delivery_time_range,:items_count,:grand_total]
    if options[:details]
      options[:include] = [:line_items,:address]
    end

    super
  end

  def delivery_time_range
    ranges = MenuProduct::LUNCH_TIMES.merge MenuProduct::DINNER_TIMES
    ranges[delivery_time.strftime('%H%M')]
  end

  def formatted_delivery_time
    ranges = MenuProduct::LUNCH_TIMES.merge MenuProduct::DINNER_TIMES

    show = ranges[delivery_time.strftime('%H%M')]
    if show
      if delivery_time.to_date == Date.today
        show + " Today"
      else
        show +"  "+ delivery_time.strftime("%a %d,%b")
      end
    else
      delivery_time
    end
  end

  def sms_formatted_delivery_time
    ranges = MenuProduct::LUNCH_TIMES.merge MenuProduct::DINNER_TIMES
    show = ranges[delivery_time.strftime('%H%M')]
    show +" "+ delivery_time.strftime("%d,%b")
  end

  def items_count
    line_items.count
  end

  #NOT using anywhere
  def self.show_upcoming_session_orders
    @orders = Order.today.includes(:user).includes(:address)
    menu = Menu.today
    if (Time.now < (menu.lunch_end_time + 1.hours))
      @orders = @orders.lunch
      @category='Lunch'
    elsif (Time.now > (menu.lunch_end_time + 1.hours)) && (Time.now < menu.dinner_end_time)
      @orders = @orders.dinner
      @category='Dinner'
    end
    @orders = @orders.order(delivery_time: :asc)
    {orders: @orders,category: @category}
  end

  def self.show_todays_orders category
    category = 'lunch' if !category
    @orders = Order.today.includes(:user,:address,:delivery_executive)
    if category=='lunch'
      @orders = @orders.lunch
    elsif category=='dinner'
      @orders = @orders.dinner
    end
    @orders = @orders.order(delivery_time: :asc)
  end

  def dispatch_with delivery_executive_id
    delivery_executive = DeliveryExecutive.find delivery_executive_id
    delivery_executive.mark_out_for_delivery
    self.delivery_executive = delivery_executive
    dispatch!
  end

  def inform_delivery_guy delivery_executive
    self.delivery_executive = delivery_executive
    if DeliveryExecutiveMessenger.inform_on_field self
      update_attributes(delivery_executive: delivery_executive)
      mark_informed!
    end
  end

  def notify_withdraw_request
    notify_delivery_executive 'withdraw_delivery_request'
  end

  def notify_reject_delivery_request
    notify_kitchen 'reject_delivery_request'
  end

  def self.search query
    @orders = where(id: query).includes(:address).includes(:user) + joins(:user).joins(:profile).where("profiles.phone_number = ?",
                                                                    query).includes(:address).includes(:user) + joins(:user).where("users.email = ?",query).includes(:address).includes(:user)

  end

  def self.find_by_date date
    Order.where("date(delivery_time) = ?",date)
  end

  def mark_feedback_asked
    update_attributes(feedback_asked: true)
  end

  def ask_for_feedback
    if(!feedback_asked and delivered?)
      mark_feedback_asked
      user.ask_for_feedback
    end
  end

  handle_asynchronously :ask_for_feedback

  def brief_line_items
    line = ''
    line_items.includes(:menu_product).includes(:product).each do |li|
      line << " #{li.product.category} =>#{li.quantity} ."
    end
    line
  end


  def cashback_for_customer_satisfaction wallet_promotion_name,custom_message
    wallet_promotion=WalletPromotion.where(name: wallet_promotion_name).first
    if user.wallet.apply_promotion wallet_promotion
      message = custom_message || "Dear #{user.name.split(' ')[0]}, Apologies for the subpar service.We've gone ahead and refunded Rs #{wallet_promotion.amount}  into your Spoonly wallet."
      user.notify_wallet message,"Refunds@Spoonly"
      UserMessenger.apologise user,message
    end
  end

  def self.to_be_cooked
    where(state: ['acknowledged','pending']).today
  end

  def self.in_dispatch_process
    where(state: ['informed_delivery_guy','dispatched']).today
  end

  def needs_delivery_fee?
    total_price < Order::MIN_TOTAL_FOR_FREE_DELIVERY
  end

  def detail_line_items
    line = ''
    line_items.includes(:menu_product).includes(:product).each do |li|
      line << "#{li.product.name}(#{li.product.category}) => #{li.quantity}"
    end
    line
  end

  private

  def record_dispatch_time
    self.dispatched_at=Time.now
  end

  def record_delivered_time
    self.delivered_at=Time.now
  end

end
