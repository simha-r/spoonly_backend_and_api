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

end
