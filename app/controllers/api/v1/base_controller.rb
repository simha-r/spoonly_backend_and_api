class Api::V1::BaseController < ApplicationController
  include CurrentCart
  respond_to :json

  skip_before_action :verify_authenticity_token



  def current_user
    @current_user ||= User.where(authentication_token:request.headers['Authorization']).first if request
    .headers['Authorization'].present?
  end

  def authenticate_user!
    render json: { errors: "Not Authenticated" }, status: :unauthorized unless current_user.present?
  end


end