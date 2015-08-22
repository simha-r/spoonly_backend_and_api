# == Schema Information
#
# Table name: card_transactions
#
#  id              :integer          not null, primary key
#  transaction_id  :string(255)
#  amount          :string(255)
#  payment_gateway :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class CardTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
