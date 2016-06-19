class Api::V1::AccountsController <Api::V1::BaseController

  before_action :authenticate_user!

  def show
    render json: current_user
  end

  def update
    if current_user.profile.update_attributes(profile_params)
      render json: current_user, status: 200
    end
  end



  private

  def profile_params
    params.permit(:phone_number,:name)
  end


end