# == Schema Information
#
# Table name: line_items
#
#  id              :integer          not null, primary key
#  product_name    :string(255)
#  menu_product_id :integer
#  order_id        :integer
#  cart_id         :integer
#  price           :float
#  quantity        :integer          default(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class LineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :cart
  belongs_to :menu_product

  delegate :product, to: :menu_product


  def decrement_count
    if quantity==1
      destroy
    else
      update_attributes(quantity: (quantity-1))
    end
  end

  def serializable_hash(options={})
    options ||={}
    options[:except] ||= [:id,:created_at,:updated_at,:cart_id,:order_id,:menu_product_id]
    options[:methods] ||= [:product_name,:vegetarian]
    super
  end

  def product_name
    product.name
  end

  def vegetarian
    product.vegetarian
  end

end
