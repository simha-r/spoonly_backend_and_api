# == Schema Information
#
# Table name: carts
#
#  id          :integer          not null, primary key
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  menu_id     :integer
#  expiry_time :datetime
#

class Cart < ActiveRecord::Base

  has_many :line_items,dependent: :destroy
  has_many :menu_products,through: :line_items
  belongs_to :menu

  def add_menu_product(menu_product_id)
    current_item = line_items.find_by(menu_product_id: menu_product_id)
    set_category MenuProduct.find(menu_product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(menu_product_id: menu_product_id)
      current_item.price = current_item.menu_product.product.price
    end
    current_item
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

  def total_cart_count
    line_items.to_a.sum &:quantity
  end

  def contains_menu_product? menu_product
    line_items.where(menu_product_id: menu_product.id).first
  end

  def set_category menu_product
    menu = menu_product.menu
    line_item_category = menu_product.category
    if category!=line_item_category
      set_menu_and_category menu,line_item_category
    end
  end

  def set_menu_and_category menu,category
    if category=='lunch'
      expiry_time = menu.lunch_order_end_time
    elsif category=='dinner'
      expiry_time = menu.dinner_order_end_time
    end
    if self.category!=category
      clear_line_items
    end
    update_attributes(menu_id: menu.id,expiry_time: expiry_time,category: category)
  end

  def expired?
    Time.now > expiry_time
  end

  def total_price
    total = 0
    line_items.each do |li|
      total = total + li.price*li.quantity
    end
    total
  end

  def clear_line_items
    line_items.destroy_all
  end

end
