class Api::V1::WalletsController < Api::V1::BaseController

  before_action :authenticate_user!,except: [:recharge]

  def show
    render json: current_user.wallet.balance
  end

  def recharge
    payment_id = params[:payment_id]
  end


end