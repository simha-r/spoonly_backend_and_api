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
    #Dont give general promotion offers for users who have already used up referral rewards as referred
    if user.has_been_referred?
      return false
    end
    if applied_for? user
      return false
    else
      UserGeneralPromotion.create!(general_promotion: self,user: user)
      user.wallet.apply_promotion self
    end
  end

  def applied_for? user
    if user.device_id.present?
      same_device_users = User.where(device_id: user.device_id)
      general_promotion = UserGeneralPromotion.where(general_promotion: self,user: same_device_users).first
    else
      general_promotion= UserGeneralPromotion.where(general_promotion: self,user: user).first
    end
    general_promotion
  end

  def enable
    update_attributes(active: true)
  end

  def disable
    update_attributes(active: false)
  end

end
