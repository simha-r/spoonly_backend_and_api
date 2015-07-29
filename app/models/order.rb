# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  delivery_time :datetime
#  state         :string(255)
#  pay_type      :string(255)
#  address_id    :integer
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  category      :string(255)
#

class Order < ActiveRecord::Base

  has_many :line_items
  belongs_to :address
  belongs_to :user



  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      #TODO Why is cart id being set to nil ? The line items wont be destroyed in a dependent destroy if so
      #TODO Or are the same line items being assigned to an order without duplicating them ?
      item.cart_id = nil
      line_items << item
    end
    category = cart.category
  end

end
