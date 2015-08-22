# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  balance    :float            default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :card_transactions
  has_many :credits
  has_many :debits

  def add_card_amount amount,payment_id,payment_gateway
    amount = amount.to_f
    new_balance = self.balance.to_f + amount
    card_transaction = CardTransaction.create(amount: amount,transaction_id: payment_id,payment_gateway: payment_gateway)
    if credit= card_transaction.create_credit(amount: amount,credit_type: 'card',latest_wallet_balance: new_balance)
      update_attributes!(balance: new_balance)
    end
  end


end
