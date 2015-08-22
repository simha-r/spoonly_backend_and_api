# == Schema Information
#
# Table name: debits
#
#  id                    :integer          not null, primary key
#  wallet_id             :integer
#  amount                :float
#  latest_wallet_balance :string(255)
#  order_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#

require 'test_helper'

class DebitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
