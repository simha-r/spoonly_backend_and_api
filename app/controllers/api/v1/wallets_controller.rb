class Api::V1::WalletsController < Api::V1::BaseController

  before_action :authenticate_user!

  def show
    render json: current_user.wallet.balance
  end


end