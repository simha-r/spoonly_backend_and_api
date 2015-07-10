class Api::V1::OrdersController < Api::V1::BaseController

  # TODO uncomment authentication later
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :json


  # POST /orders
  # POST /orders.json
  def create
    @order = Order.create! order_params
    params[:line_item].each { |li| @order.line_items.create!(custom_line_item_params(li)) }
    render json: @order
  rescue Exception=>e
    HealthyLunchUtils.log_error e.message,e
    render status: :error
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:address_id, :pay_type)
  end

  def custom_line_item_params(par = {})
    par.permit(:product_id)
  end

  def line_item_params #this is the default one, without parameters
    custom_line_item_params(params.require(:line_item))
  end


end
