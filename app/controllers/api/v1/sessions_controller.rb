class Api::V1::SessionsController < Api::V1::BaseController

  include Api::V1::SessionsHelper

  # POST /api/sessions
  # curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/json" -X POST -d '{"provider": "provider", "access_token": "access_token"}'  http://localhost:3000/api/sessions
  def create
    #Find email for that provider,uid,access_token
    if get_user_info params['access_token'],params['provider']
      device_id = params[:android_id].present? ? params[:android_id] : params[:telephony_manager_device_id]
      auth = {provider: params['provider'],uid: @uid,token: params['access_token'],
              info: {email: @email,name: @name,pic_url: @picture,gender: @gender,first_name: @first_name,last_name: @last_name,profile_link: @profile_link},device_id: device_id}

      user = User.from_omniauth(auth, current_user)
      if user.persisted?
        user.delay(run_at: 8.seconds.from_now).notify_promotion_screen if user.login_type=='new_user'
        user.confirm!
        render json: user, status: 200
      else
        render json: { errors: "Authentication failed" }, status: 422
      end
    else
      head 422,content_type: 'application/json'
    end
  end

end