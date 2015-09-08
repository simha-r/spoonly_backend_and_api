class Company::CurrentOrdersController < Company::BaseController


  def index
    @search_results = Order.search(params[:search]) if params[:search]
    results = Order.show_upcoming_session_orders
    @orders = results[:orders]
    @category = results[:category]
  end

  def multi_assign
    @orders = Order.where(id: params[:order_ids])
    if @orders.present?
      @orders.each {|o| o.dispatch_with params[:delivery_executive_id]}
      redirect_to [:acknowledged,:company,:current_orders], notice: 'Successfully assigned to delivery executive'
    else
      redirect_to [:acknowledged,:company,:current_orders], alert: 'Please select an order to dispatch !'
    end
  end

  def pending
    results = Order.show_upcoming_session_orders
    @orders = results[:orders].pending
    @category = results[:category]
  end

  def acknowledged
    results = Order.show_upcoming_session_orders
    @orders = results[:orders].acknowledged
    @category = results[:category]
  end

  def dispatched
    results = Order.show_upcoming_session_orders
    @orders = results[:orders].dispatched.includes :delivery_executive
    @category = results[:category]
  end

  def delivered
    @order = Order.find params[:order_id] if params[:order_id]
    results = Order.show_upcoming_session_orders
    @orders = results[:orders].delivered
    @category = results[:category]
  end

  def cancelled
    results = Order.show_upcoming_session_orders
    @orders = results[:orders].cancelled
    @category = results[:category]
  end


end
