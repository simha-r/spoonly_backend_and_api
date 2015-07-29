class Customer::OrdersController < ApplicationController

  include CurrentCart

  before_action :authenticate_user!,except: [:new]

  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  helper_method :resource_name, :resource_class, :resource, :devise_mapping


  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to root_path, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)


    if @order.category=='lunch'
      @order.delivery_time = DateTime.parse(order_params['delivery_time'])
    end

    if @order.save
      byebug
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      # OrderNotifier.received(@order).deliver
      redirect_to success_customer_orders_path,notice: 'Your order has been created !'
    else
       render action: 'new'
    end
  end

  def success

  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    resource.class
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:address_id, :pay_type,:category,:delivery_time)
  end


end
