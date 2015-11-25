class Company::UsersController < Company::BaseController

  before_filter :authenticate_admin!
  before_filter :load_resource, except: [:index,:search]

  def index
    @search_term = params[:search_term]
    if @search_term.present?
      wildcard_search = "%#{@search_term}%"
      @users = User.where("email iLIKE ?", wildcard_search).includes(:profile,:referrals,:wallet).paginate page: params[:page]
    else
      @users = User.order(created_at: :desc).includes(:profile,:referrals,:wallet).paginate page: params[:page]
    end
  end

  def show

  end

  def wallet
    
  end

  def search

    render 'index'
  end

  def give_money
    wallet_promotion_name = params[:wallet_promotion_name]
    custom_message=params[:message].strip.present? ? params[:message] : nil
    @user.cashback_for_customer_satisfaction wallet_promotion_name,custom_message
    redirect_to request.referrer, notice: 'success'
  end

  private

  def load_resource
    @user =User.find params[:id]
  end

end