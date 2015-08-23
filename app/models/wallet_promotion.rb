class WalletPromotion < ActiveRecord::Base

  has_many :credits , as: :payment_mechanism

end
