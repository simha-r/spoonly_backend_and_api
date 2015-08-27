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

class Debit < ActiveRecord::Base
  belongs_to :wallet
  belongs_to :order

  validates_presence_of :amount,:latest_wallet_balance,:order_id,:wallet
  validates :amount, :numericality => {:greater_than => 0}
end
