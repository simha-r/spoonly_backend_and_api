class Customer::SessionsController < Customer::BaseController

  def new
    redirect_to root_path
  end

  def create
    redirect_to root_path
  end

  def destroy
    sign_out current_user
    cookies.delete(:customer)
    session[:login_type] = nil
    redirect_to root_path
  end

end
