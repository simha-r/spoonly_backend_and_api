class Company::CompanyUsersController < Company::BaseController

  before_filter :authenticate_admin!
  before_filter :set_company_user,except: [:index,:new,:create]

  def index
    @company_users = CompanyUser.all
  end

  def enable_otp
    if @company_user.enable_otp
      redirect_to company_company_users_path, notice: 'OTP enabled. Please note down the otp
secret or Scan the qr code in google authenticator'
    end
  end

  def disable_otp
    if @company_user.disable_otp
      redirect_to request.referrer,notice: 'OTP has been disabled'
    end
  end

  def show_otp
    # @qr = RQRCode::QRCode.new( @company_user.current_otp,:size => 4, :level => :h)
  end

  def new
    @company_user = CompanyUser.new
  end

  def create
    @company_user = CompanyUser.new(company_user_params)
    if @company_user.save
      redirect_to company_company_users_path
    else
      render :new
    end
  end

  def update
    if @company_user.update_attributes(company_user_params)
      redirect_to company_company_users_path
    else
      render :new
    end
  end

  def edit_roles

  end

  def update_roles
    if params[:admin] == "1"
      @company_user.grant(:admin)
    elsif params[:admin] == "0"
      @company_user.remove_role(:admin)
    end
    if params[:delivery_executive] == "1"
      @company_user.grant(:delivery_executive)
    elsif params[:delivery_executive] == "0"
      @company_user.remove_role(:delivery_executive)
    end

    if params[:dispatcher] == "1"
      @company_user.grant(:dispatcher)
    elsif params[:dispatcher] == "0"
      @company_user.remove_role(:dispatcher)
    end
    redirect_to edit_roles_company_company_user_path(@company_user)
  end

  private

  def set_company_user
    @company_user = CompanyUser.find params[:id]
  end

  def company_user_params
    params.require(:company_user).permit(:email,:password,:password_confirmation)
  end

end
