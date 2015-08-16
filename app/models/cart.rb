# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Cart < ActiveRecord::Base

  has_many :line_items,dependent: :destroy
  has_many :menu_products,through: :line_items

  def add_menu_product(menu_product_id)
    current_item = line_items.find_by(menu_product_id: menu_product_id)
    set_category MenuProduct.find(menu_product_id).category
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(menu_product_id: menu_product_id)
      current_item.price = current_item.menu_product.product.price
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def quantity_of_menu_product menu_product
    line_item  = line_items.where(menu_product_id: menu_product.id).first
    if line_item
     line_item.quantity
    else
      0
    end

  end

  def line_item_of menu_product
    line_items.where(menu_product_id: menu_product.id).first
  end

  def distinct_cart_count
    line_items.count
  end

  def contains_menu_product? menu_product
    line_items.where(menu_product_id: menu_product.id).first
  end

  def set_category line_item_category
    if category!=line_item_category
      update_attributes(category: line_item_category)
      line_items.destroy_all
    end
  end
end
