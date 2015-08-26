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

class CardTransaction < ActiveRecord::Base

  has_one :credit,as: :payment_mechanism
  validates_uniqueness_of :transaction_id

end
