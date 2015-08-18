class Api::V1::FeedbacksController < Api::V1::BaseController

  before_action :authenticate_user!

  def create
    @feedback = current_user.feedbacks.create(feedback_params)
    head 200
  end



  private

  def feedback_params
    params.permit(:overall_rating,:comment,:user_id)
  end

end