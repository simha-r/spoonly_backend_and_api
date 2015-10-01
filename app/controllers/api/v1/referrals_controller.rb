class Api::V1::ReferralsController < Api::V1::BaseController

  def create
    referral_code = params[:referral_code]

    if referral_code[0..1].upcase=='RC'
      #It is a referral code
      referrer = User.where(referral_code: referral_code).first
      if current_user.referred || !referrer || current_user.orders.delivered.present? || (current_user.referral_code==referral_code)
         render json: {error: 'Invalid code'},status: 500
        #TODO Send error message
      else
        if referrer.refer_user current_user
          render json: {text: 'Promotion has been applied!'}
        end
      end
    else
      #Not a referral code
      #TODO use this for applying general promo codes
      general_promotion = GeneralPromotion.where(promo_code: referral_code).active.first
      if general_promotion.apply_for current_user
        render json: {text: 'Promotion has been applied!'}
      else
        render json: {error: 'Invalid code'},status: 500
      end
    end
  end

end