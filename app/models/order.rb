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
#

class Order < ActiveRecord::Base

  include AASM

  has_many :line_items
  belongs_to :address
  belongs_to :user
  belongs_to :delivery_executive
  has_one :debit

  validates_presence_of :address_id, :user_id, :delivery_time, :category
  validates_presence_of :category, in: MenuProduct::CATEGORIES


  aasm column: 'state' do

    state :new, initial: true
    state :pending
    state :acknowledged
    state :dispatched
    state :delivered
    state :cancelled

    event :start_process,after: [:notify_success],before:[:auto_debit_amount] do
      transitions from: :new, to: :pending
    end

    event :acknowledge do
      transitions from: :pending, to: :acknowledged
    end

    event :dispatch do
      transitions from: :acknowledged, to: :dispatched
    end

    event :deliver,after: [:apply_cashback_promotions] do
      transitions from: :dispatched,to: :delivered
    end

    event :cancel,after: [:notify_cancel,:refund_prepaid_amount] do
      transitions from: [:pending,:acknowledged,:dispatched], to: :cancelled
    end

  end

  alias_method :start_process, :start_process!
  alias_method :acknowledge, :acknowledge!
  alias_method :dispatch, :dispatch!
  alias_method :deliver, :deliver!
  alias_method :cancel, :cancel!


  scope :delivered,-> {where(state: 'delivered')}

  def auto_debit_amount
    user.wallet.debit_amount_for_order self
  end

  def refund_prepaid_amount
    user.wallet.refund_cancelled_order self
  end

  def cash_to_pay
    prepaid_amount > 0 ?  (total_price - prepaid_amount) : total_price
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
  end
  handle_asynchronously :notify_user,queue: 'user_notifications'

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

  def is_first?
    user.orders.delivered.order('created_at DESC').first==self
  end

  def apply_cashback_promotions
    if is_first?
      referral = user.referred
      referral.apply_referrer_promotions
    end
  end

  handle_asynchronously :apply_cashback_promotions #,:run_at => Proc.new { 24.hours.from_now }

  def serializable_hash(options={})
    options ||={}
    options[:except] ||= [:user_id,:created_at,:updated_at,:delivery_executive_id,:address_id]
    options[:methods] = [:cash_to_pay,:prepaid_amount,:total_price,:delivery_time_range]
    if options[:details]
      options[:include] = [:line_items]
    end

    super
  end

  def delivery_time_range
    ranges = MenuProduct::LUNCH_TIMES.merge MenuProduct::DINNER_TIMES
    ranges[delivery_time.strftime('%H%M')]
  end

end
