class Api::V1::ReferralsController < Api::V1::BaseController

  def create
    referrer = User.where(referral_code: params[:referral_code]).first
    if current_user.referred || !referrer
       render json: {error: 'Invalid code'},status: 500
      #TODO Send error message
    else
      if referrer.refer_user current_user
        render json: {text: 'Promotion has been applied'}
      end
    end
  end

end