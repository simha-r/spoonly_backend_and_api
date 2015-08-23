class Api::V1::ReferralsController < Api::V1::BaseController

  def create
    referrer = User.where(referral_code: params[:referral_code]).first
    if current_user.referred || !referrer
      #TODO Send error message
    else
      referrer.refer_user current_user
    end
  end

end