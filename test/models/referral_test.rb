# == Schema Information
#
# Table name: referrals
#
#  id          :integer          not null, primary key
#  referrer_id :integer
#  referred_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ReferralTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
