class Company::UsersController < ApplicationController


  before_filter :set_user,except: [:index]

  def index
    @company_users = CompanyUser.all
  end

  def enable_otp

  end

  def disable_otp

  end

  def show_otp
    render :qrcode => current_user.otp_sercet
  end

end
