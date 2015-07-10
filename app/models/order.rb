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
#

class Order < ActiveRecord::Base

  has_many :line_items
  belongs_to :address
  belongs_to :user

end
