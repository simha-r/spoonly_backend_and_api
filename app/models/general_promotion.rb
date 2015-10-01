# == Schema Information
#
# Table name: general_promotions
#
#  id          :integer          not null, primary key
#  promo_code  :string(255)
#  name        :string(255)
#  description :string(255)
#  amount      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean          default(FALSE)
#

class GeneralPromotion < ActiveRecord::Base
  has_many :user_general_promotions
  has_many :users,through: :user_general_promotions
  has_many :credits , as: :payment_mechanism

  scope :active, -> {where(active: true)}


  def apply_for user

    return false if !active

    user_general_promotion = UserGeneralPromotion.where(general_promotion: self,user: user).first
    if user_general_promotion
      return false
    else
      UserGeneralPromotion.create!(general_promotion: self,user: user)
      user.wallet.apply_promotion self
    end
  end

end
