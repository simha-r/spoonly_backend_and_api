class Company::FeedbacksController < Company::BaseController

  def index
    @feedbacks = Feedback.order(:created_at).paginate page: params[:page]
  end

end
