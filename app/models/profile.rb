# == Schema Information
#
# Table name: profiles
#
#  id                             :integer          not null, primary key
#  name                           :string(255)
#  phone_number                   :string(255)
#  phone_number_verified          :boolean
#  user_id                        :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#  phone_number_verification_code :string(255)
#  phone_number_verify_tries      :integer
#

class Profile < ActiveRecord::Base
  belongs_to :user
end
