# == Schema Information
#
# Table name: profiles
#
#  id                               :integer          not null, primary key
#  name                             :string(255)
#  phone_number                     :string(255)
#  phone_number_verification_req_id :string(255)
#  phone_number_verified            :boolean
#  user_id                          :integer
#  created_at                       :datetime
#  updated_at                       :datetime
#

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
