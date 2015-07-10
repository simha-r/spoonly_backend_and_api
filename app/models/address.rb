# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address_type :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Address < ActiveRecord::Base

  belongs_to :address

end
