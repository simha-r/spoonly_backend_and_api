# == Schema Information
#
# Table name: referrals
#
#  id          :integer          not null, primary key
#  referrer_id :integer
#  referred_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Referral < ActiveRecord::Base

  belongs_to :referrer,class_name: 'User'
  belongs_to :referred,class_name: 'User'

  after_create :apply_referred_promotion


  def apply_referred_promotion
    wallet_promotion = WalletPromotion.where(name: 'referred_signup').first
    referred.apply_wallet_promotion wallet_promotion
  end

  def apply_referrer_promotions
    wallet_promotion = WalletPromotion.where(name: 'referrer_signup').first
    referrer.apply_wallet_promotion wallet_promotion
  end

end


