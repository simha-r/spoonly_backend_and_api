class Company::CompanyUsersController < Company::BaseController


  before_filter :set_company_user,except: [:index]

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

  private

  def set_company_user
    @company_user = CompanyUser.find params[:id]
  end

end
