# == Schema Information
#
# Table name: delivery_executives
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  phone_number :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class DeliveryExecutive < ActiveRecord::Base

  has_many :orders

  def delivered_orders
    orders.where(state: 'delivered')
  end

end
