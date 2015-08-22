# == Schema Information
#
# Table name: wallet_items
#
#  id                   :integer          not null, primary key
#  wallet_id            :integer
#  credit               :boolean          default(FALSE)
#  amount               :float
#  wallet_balance_after :float
#  order_id             :integer
#  item_type            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class WalletItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
