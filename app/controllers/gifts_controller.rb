class GiftsController < Customer::BaseController

  layout :layout_by_resource

  def show
    referral_code = params[:id]
    @referrer = User.where(referral_code: referral_code).first
  end

  def layout_by_resource
    "gifts"
  end


end
