class Api::V1::ReferralsController < Api::V1::BaseController

  def create
    referral_code = params[:referral_code]

    if referral_code[0..1].upcase=='RC'
      #It is a referral code
      referrer = User.where(referral_code: referral_code).first
      if(referrer && referrer.refer_user(current_user))
        render json: {text: 'Promotion has been applied!'}
      else
        render json: {error: 'Invalid code'},status: 500
      end
    else
      #Not a referral code
      general_promotion = GeneralPromotion.where(promo_code: referral_code).active.first

      if(general_promotion && general_promotion.apply_for(current_user))
        render json: {text: 'Promotion has been applied!'}
      else
        render json: {error: 'Invalid code'},status: 500
      end
    end
  end

end