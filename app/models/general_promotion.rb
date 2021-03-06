# == Schema Information
#
# Table name: general_promotions
#
#  id                :integer          not null, primary key
#  promo_code        :string(255)
#  name              :string(255)
#  description       :string(255)
#  amount            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  active            :boolean          default(FALSE)
#  growth_partner_id :integer
#

class GeneralPromotion < ActiveRecord::Base
  has_many :user_general_promotions
  has_many :users,through: :user_general_promotions
  has_many :credits , as: :payment_mechanism
  belongs_to :growth_partner

  scope :active, -> {where(active: true)}


  def apply_for user
    return false if !active
    #Dont give general promotion offers for users who have already used up referral rewards as referred
    if user.has_been_referred?
      return false
    end
    general_promotions = GeneralPromotion.all
    if GeneralPromotion.applied_for?(user,general_promotions)
      return false
    end

    if applied_for? user
      return false
    else
      UserGeneralPromotion.create!(general_promotion: self,user: user)
      growth_partner.notify_incentive if growth_partner
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

  def self.applied_for? user,general_promotions
    if user.device_id.present?
      same_device_users = User.where(device_id: user.device_id)
      general_promotion = UserGeneralPromotion.where(general_promotion: general_promotions,user: same_device_users).first
    else
      general_promotion= UserGeneralPromotion.where(general_promotion: general_promotions,user: user).first
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
