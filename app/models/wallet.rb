# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  balance    :float
#  created_at :datetime
#  updated_at :datetime
#

class Wallet < ActiveRecord::Base
  belongs_to :user

  def add_amount amount
    new_balance = balance.to_f + amount.to_f
    update_attributes!(balance: new_balance)
  end

end
