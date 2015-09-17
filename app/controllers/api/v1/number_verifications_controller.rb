class Api::V1::NumberVerificationsController < Api::V1::BaseController

  before_action :authenticate_user!


  # POST /api/number_verifications params {phone_number: 98989898898}
  def start

    response = NumberVerification.start current_user,params[:phone_number]
    if response
      render json: {},status: :ok
    else
      head 422,content_type: 'application/json'
    end
  end

  # GET /api/number_verifications/resend
  def resend
    response = NumberVerification.resend current_user
    if response
      render json: {},status: :ok
    else
      head 422,content_type: 'application/json'
    end
  end

  # POST /api/number_verifications params {verification_code: 4567}
  def finish
    if NumberVerification.finish current_user,params[:verification_code]
      current_user.mark_number_verified
      render json: current_user, status: :ok
    else
      head 422,content_type: 'application/json'
    end
  end

end