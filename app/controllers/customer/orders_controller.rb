class Customer::OrdersController < ApplicationController

  include CurrentCart

  before_action :authenticate_user!,except: [:new]

  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy,:success]
  helper_method :resource_name, :resource_class, :resource, :devise_mapping


  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirect_to root_path, notice: "Your cart is empty"
      return
    end
    @order = Order.new
    sum_of_items = 0
    @cart.line_items.each { |item| sum_of_items += (item.quantity * item.price) }


    #TODO Refactor delivery_fee logic to a method
    if @cart.category=='lunch'
      @menu  = Menu.current_lunch

      if @menu.menu_date == Date.today
        if Time.now < Menu.today.lunch_start_time
          delivery_fee = 5
        else
          delivery_fee = 15
        end
      else
        # It is after 3:30 and he is seeing next day menu..so only 5 rs delivery
        delivery_fee = 5
      end
    else
      delivery_fee = 10
    end

    @delivery_fee = delivery_fee

    @cart_total = sum_of_items + @delivery_fee
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.build(order_params)
    menu_date = @cart.menu.menu_date
    @order.delivery_time = "#{menu_date.year}-#{menu_date.month}-#{menu_date.day}-"+order_params[:delivery_time]
    @order.add_line_items_from_cart(@cart)
    @order.category = @cart.category
    if order_params[:delivery_time].present?
      if @order.save

        #TODO Refactor delivery_fee logic to a method
        if @cart.category=='lunch'
          @menu  = Menu.current_lunch

          if @menu.menu_date == Date.today
            if Time.now < Menu.today.lunch_start_time
              delivery_fee = 5
            else
              delivery_fee = 15
            end
          else
            # It is after 3:30 and he is seeing next day menu..so only 5 rs delivery
            delivery_fee = 5
          end
        else
          delivery_fee = 10
        end
        @order.update_attributes(delivery_fee: delivery_fee)
        #TODO Why not @cart.destroy
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        @order.start_process!
        # OrderNotifier.received(@order).deliver
        respond_to do |format|
          format.html {        redirect_to success_customer_order_path @order,notice: 'Your order has been created !'     }
          format.js {render 'customer/orders/create_success'}
        end

      else
        respond_to do |format|
          format.html { render action: 'new'}
          format.js {render 'customer/orders/create_failure'}
        end
      end
    else
      respond_to do |format|
        format.html { render action: 'new'}
        format.js {render 'customer/orders/create_failure'}
      end
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
