class Company::DeliveryExecutivesController < Company::BaseController

  def index
    @delivery_executives = DeliveryExecutive.all
  end

  def mark_available
    @delivery_executive = DeliveryExecutive.find params[:id]
    @delivery_executive.mark_available
    redirect_to company_delivery_executives_path,notice: 'Marked available successfully'
  end

end