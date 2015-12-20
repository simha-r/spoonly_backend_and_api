class Api::V1::OrdersController < Api::V1::BaseController

  before_action :authenticate_user!
  before_action :set_order, only: [:show, :cancel]

  respond_to :json

  # POST /api/orders
  # POST /api/orders.json
  def create
    @order = current_user.orders.create! order_params
    params[:line_item].each do |li|
      menu_product = MenuProduct.find custom_line_item_params(li)['menu_product_id']
      # Slowly change it to menu_product.price...as that is the price that gets recorded
      new_params = custom_line_item_params(li).merge({price: menu_product.product.price})
      @order.line_items.create!(new_params)
    end
    if @order.needs_delivery_fee?
      @order.update_attributes(delivery_fee: Order::DELIVERY_FEE)
    end
    @order.start_process!
    render json: @order
  rescue Exception=>e
    HealthyLunchUtils.log_error e.message,e
    @order.destroy if @order
    render status: :error
  end

  def index
    @orders = current_user.orders.includes(:debit).includes(:line_items).order(delivery_time: :desc)
    render json: {orders: @orders}
  end

  def show
    render json: @order.to_json(details: true)
  end

  def cancel

  end

  def preview
    item_total = 0
    item_quantity = 0
    if params[:line_item].present?
      params[:line_item].each do |li|
        menu_product = MenuProduct.find custom_line_item_params(li)['menu_product_id']
        quantity = custom_line_item_params(li)['quantity'].to_f
        item_quantity = item_quantity + quantity
        # When u add item to menu...and later change product price...it doesnt get reflected in menu_product price..and it shouldnt..so have a menu to edit the menu product price after a menu priduct has been created
        item_total = item_total + menu_product.product.price*quantity
      end
      delivery_fee = (item_total < Order::MIN_TOTAL_FOR_FREE_DELIVERY) ? Order::DELIVERY_FEE : 0
      bill_total = item_total + delivery_fee
      grand_total = bill_total

      prepaid_amount = ((grand_total >= current_user.wallet.balance) ? current_user.wallet.balance : grand_total )
      cash_to_pay = (prepaid_amount > 0) ?  (grand_total - prepaid_amount) : grand_total

      response = {delivery_fee: delivery_fee,grand_total: grand_total,item_total: item_total,item_quantity: item_quantity,prepaid_amount: prepaid_amount,cash_to_pay: cash_to_pay}
      render json: response
    end
      # {delivery_fee: delivery_fee, promotion: {coupon_code: BACK50,discount: 50},wallet_cash_used: 40 }
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

  def set_order
    @order = current_user.orders.find params[:id]
  end

end
