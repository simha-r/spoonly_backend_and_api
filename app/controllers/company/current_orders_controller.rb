class Company::CurrentOrdersController < Company::BaseController

  def index
    redirect_to [:lunch,:company,:current_orders]
  end


  def lunch
    @category = 'lunch'
    @search_results = Order.search(params[:search]) if params[:search]
    @orders = Order.show_todays_orders @category
    render 'index'
  end

  def dinner
    @category = 'dinner'
    @search_results = Order.search(params[:search]) if params[:search]
    @orders = Order.show_todays_orders @category
    render 'index'
  end

  def multi_assign
    @orders = Order.where(id: params[:order_ids])
    if @orders.present?
      @orders.each {|o| o.dispatch_with params[:delivery_executive_id]}
      redirect_to request.referrer, notice: 'Successfully assigned to delivery executive'
    else
      redirect_to request.referrer, alert: 'Please select an order to dispatch !'
    end
  end

  def pending
    @category = params[:category] || 'lunch'
    @orders = Order.show_todays_orders @category
    @orders = @orders.pending
  end

  def acknowledged
    @category = params[:category] || 'lunch'
    @orders = Order.show_todays_orders @category
    @orders = @orders.acknowledged
  end

  def dispatched
    @category = params[:category] || 'lunch'
    @orders = Order.show_todays_orders @category
    @orders = @orders.dispatched.includes :delivery_executive
  end

  def delivered
    @category = params[:category] || 'lunch'
    @order = Order.find params[:order_id] if params[:order_id]
    @orders = Order.show_todays_orders @category
    @orders = @orders.delivered
  end

  def cancelled
    @category = params[:category] || 'lunch'
    results = Order.show_todays_orders @category
    @orders = @orders.cancelled
  end


end
