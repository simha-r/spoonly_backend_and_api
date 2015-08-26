# == Schema Information
#
# Table name: wallet_promotions
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#

class WalletPromotion < ActiveRecord::Base

  has_many :credits , as: :payment_mechanism

end
