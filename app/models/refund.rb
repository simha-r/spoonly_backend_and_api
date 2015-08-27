class Refund < ActiveRecord::Base

  has_many :credits,as: :payment_mechanism

end
