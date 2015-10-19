class Company::UsersController < Company::BaseController

  before_filter :authenticate_admin!
  before_filter :load_resource, except: [:index]

  def index
    @users = User.order(created_at: :desc).paginate page: params[:page]
  end

  def show

  end

  def wallet
    
  end

  private

  def load_resource
    @user =User.find params[:id]
  end

end