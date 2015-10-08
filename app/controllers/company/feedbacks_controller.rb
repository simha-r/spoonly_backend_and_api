class Company::FeedbacksController < Company::BaseController

  def index
    @feedbacks = Feedback.order(created_at: :desc).paginate page: params[:page]
  end

end
