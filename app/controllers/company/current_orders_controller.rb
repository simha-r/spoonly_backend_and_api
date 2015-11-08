class Company::CurrentOrdersController < Company::BaseController

  def index
    @category = params[:category] || 'lunch'
    @search_results = Order.search(params[:search]) if params[:search]
    @orders = Order.show_todays_orders @category
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

  def chef_summary
    @orders = Order.today.lunch
  end

  def pending
    @category = params[:category] || 'lunch'
    @orders = Order.show_todays_orders @category
    @orders = @orders.pending.includes(:user,:address,:delivery_executive)
  end

  def acknowledged
    @category = params[:category] || 'lunch'
    @orders = Order.show_todays_orders @category
    @orders = @orders.acknowledged_or_informed_delivery_guy.includes(:user,:address,:delivery_executive)
  end

  def dispatched
    @category = params[:category] || 'lunch'
    @orders = Order.show_todays_orders @category
    @orders = @orders.dispatched.includes(:user,:address,:delivery_executive)
  end

  def delivered
    @category = params[:category] || 'lunch'
    @order = Order.find params[:order_id] if params[:order_id]
    @orders = Order.show_todays_orders @category
    @orders = @orders.delivered.includes(:user,:address,:delivery_executive)
  end

  def cancelled
    @category = params[:category] || 'lunch'
    results = Order.show_todays_orders @category
    @orders = @orders.cancelled
  end


end
