class Company::Field::BaseController < Company::BaseController

  layout 'field/application'

  before_filter :authenticate_delivery_executive

  def authenticate_delivery_executive
    @delivery_executive = DeliveryExecutive.where(email: current_company_user.email).first
    redirect_to root_path unless current_company_user.has_role? :delivery_executive
  end

end