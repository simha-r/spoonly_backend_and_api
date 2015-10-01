# == Schema Information
#
# Table name: general_promotions
#
#  id          :integer          not null, primary key
#  promo_code  :string(255)
#  name        :string(255)
#  description :string(255)
#  amount      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean          default(FALSE)
#

require 'test_helper'

class GeneralPromotionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
