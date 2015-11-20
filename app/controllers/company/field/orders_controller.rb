class Company::Field::OrdersController < Company::Field::BaseController

  def index
    @undelivered_orders = @delivery_executive.orders.where(state: ['informed_delivery_guy','dispatched']).today
    @delivered_orders = @delivery_executive.orders.where(state: ['delivered']).today

  end

  def accept
    @order = Order.find params[:id]
    if @order.mark_dispatched!
      redirect_to request.referrer,notice: 'Successfully Accepted Order!'
    end
  end

  def mark_delivered
    @order = Order.find params[:id]
    if @order.deliver!
      redirect_to request.referrer,notice: 'Successfully Marked Delivered!'
    end
  end

end