class Api::V1::OrdersController < Api::V1::BaseController

  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  respond_to :json

  # POST /api/orders
  # POST /api/orders.json
  def create
    @order = current_user.orders.create! order_params
    params[:line_item].each do |li|
      menu_product = MenuProduct.find custom_line_item_params(li)['menu_product_id']
      new_params = custom_line_item_params(li).merge({price: menu_product.product.price})
      @order.line_items.create!(new_params)
    end
    @order.start_process!
    render json: @order
  rescue Exception=>e
    HealthyLunchUtils.log_error e.message,e
    @order.destroy if @order
    render status: :error
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:address_id, :pay_type,:delivery_time,:category)
  end

  def custom_line_item_params(par = {})
    par.permit(:menu_product_id,:quantity)
  end

  def line_item_params #this is the default one, without parameters
    custom_line_item_params(params.require(:line_item))
  end

end
