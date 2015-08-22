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
  has_one :wallet_item

  validates_presence_of :address_id, :user_id, :delivery_time, :category
  validates_presence_of :category, in: MenuProduct::CATEGORIES


  aasm column: 'state' do

    state :new, initial: true
    state :pending
    state :acknowledged
    state :dispatched
    state :delivered
    state :cancelled

    event :start_process,after: [:notify_kitchen,:notify_user] do
      transitions from: :new, to: :pending
    end

    event :acknowledge do
      transitions from: :pending, to: :acknowledged
    end

    event :dispatch do
      transitions from: :acknowledged, to: :dispatched
    end

    event :deliver do
      transitions from: :dispatched,to: :delivered
    end


  end

  def notify_kitchen
    Pusher['orders'].trigger('purchased', {
      message: 'New Order Created..Refresh your browser to see it'
    })
  rescue Exception => e
    HealthyLunchUtils.log_error e.message,e
  end

  def notify_user
    UserMailer.order_success(self).deliver
    #TODO Send sms confirmation
  end

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      #cart id being set to nil for each line item thereby disasociating it from the cart
      #The same line items are being assigned to an order
      item.cart_id = nil
      line_items << item
    end
    category = cart.category
  end


end
