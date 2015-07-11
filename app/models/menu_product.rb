# == Schema Information
#
# Table name: menu_products
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  product_id :integer
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MenuProduct < ActiveRecord::Base
  belongs_to :menu
  belongs_to :product
end
