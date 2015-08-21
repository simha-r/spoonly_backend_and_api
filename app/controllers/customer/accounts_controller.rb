class Customer::AccountsController < Customer::BaseController

  before_filter :authenticate_user!

  def show
  end


end