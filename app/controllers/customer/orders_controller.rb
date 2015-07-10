class Customer::OrdersController < ApplicationController

  include CurrentCart

  before_action :authenticate_user_before_checkout!,except: [:new_trial]

  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  helper_method :resource_name, :resource_class, :resource, :devise_mapping


  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to home_customer_products_path, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  def new_trial
    store_specific_location new_customer_order_path
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderNotifier.received(@order).deliver
        format.html { redirect_to store_url, notice:
          I18n.t('.thanks') }
        format.json { render action: 'show', status: :created,
                             location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors,
                             status: :unprocessable_entity }
      end
    end
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
    params.require(:order).permit(:name, :address, :email, :pay_type)
  end

  def authenticate_user_before_checkout!
    if !user_signed_in?
      redirect_to new_trial_orders_path
      return
    end
  end

end
