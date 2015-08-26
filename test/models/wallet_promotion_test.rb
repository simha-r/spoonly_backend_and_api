# == Schema Information
#
# Table name: wallet_promotions
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class WalletPromotionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
