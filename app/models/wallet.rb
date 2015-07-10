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
end
