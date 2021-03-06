class Company::UsersController < Company::BaseController

  before_filter :authenticate_admin!
  before_filter :load_resource, except: [:index,:search]

  def index
    @search_term = params[:search_term]
    @referred_by = params[:referred_by]
    if @search_term.present? || @referred_by.present?
      @users = User.search @search_term,@referred_by
    else
      case params['sort_by']
        when 'orders'
          if params['order']=='asc'
            @users = User.order(orders_count: :asc)
          else
            @users = User.order(orders_count: :desc)
          end
        when 'referrals'
          if params['referrals']=='asc'
            @users = User.order(referrals_count: :asc)
          else
            @users = User.order(referrals_count: :desc)
          end
        else
          @users = User.order(created_at: :desc)
      end
    end
    @users  = @users.includes(:profile,:referrals,:wallet).paginate page: params[:page]
  end

  def feedbacks
    @feedbacks = @user.feedbacks
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