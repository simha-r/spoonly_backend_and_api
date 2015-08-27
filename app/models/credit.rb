# == Schema Information
#
# Table name: credits
#
#  id                     :integer          not null, primary key
#  wallet_id              :integer
#  amount                 :float
#  latest_wallet_balance  :string(255)
#  credit_type            :string(255)
#  payment_mechanism_id   :integer
#  payment_mechanism_type :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class Credit < ActiveRecord::Base
  belongs_to :wallet
  belongs_to :payment_mechanism,polymorphic: true

  CREDIT_TYPES = ['card','promotion','refund']

  validates_presence_of :wallet,:payment_mechanism,:amount
  validates_presence_of :latest_wallet_balance,:credit_type
  validates :credit_type, inclusion: {in: CREDIT_TYPES}
  validates :payment_mechanism,presence: true


   # ALL promotions are credits into the user wallet
  def self.promotions
    where(credit_type: 'promotion')
  end

  def self.card_transactions
    where(credit_type: 'card')
  end

end
