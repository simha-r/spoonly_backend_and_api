class Company::ReferralsController < Company::BaseController

  def index
    @referrals = Referral.order(created_at: :desc).paginate page: params[:page]
  end

end
