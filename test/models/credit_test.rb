# == Schema Information
#
# Table name: credits
#
#  id                    :integer          not null, primary key
#  wallet_id             :integer
#  amount                :float
#  latest_wallet_balance :string(255)
#  card_transaction_id   :integer
#  credit_type           :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'test_helper'

class CreditTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
