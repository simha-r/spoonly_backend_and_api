class Api::V1::AccountsController <Api::V1::BaseController

  before_action :authenticate_user!

  def show
    render json: current_user
  end


end