class GiftsController < Customer::BaseController

  def show
    referral_code = params[:id]
    @referrer = User.where(referral_code: referral_code).first
  end


end