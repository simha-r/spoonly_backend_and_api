class Api::V1::SessionsController < Api::V1::BaseController

  include Api::V1::SessionsHelper

  # POST /api/sessions
  # curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/json" -X POST -d '{"provider": "provider", "access_token": "access_token"}'  http://localhost:3000/api/sessions
  def create
    #Find email for that provider,uid,access_token
    get_user_info params[:access_token],params[:provider]
    auth = {provider: params[:provider],uid: @uid,token: params[:access_token],info: {email: @email}}

    user = User.from_omniauth(auth, current_user)
    if user.persisted?
      user.confirm!
      render json: user, status: 200
    else
      render json: { errors: "Invalide email or password" }, status: 422
    end
  end

end