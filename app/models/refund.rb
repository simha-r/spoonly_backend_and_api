# == Schema Information
#
# Table name: refunds
#
#  id          :integer          not null, primary key
#  description :string(255)
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Refund < ActiveRecord::Base

  has_many :credits,as: :payment_mechanism

end
