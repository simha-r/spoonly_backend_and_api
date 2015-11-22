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

  def reject
    @order = Order.find params[:id]
    if @order.reject_delivery_request!
      redirect_to request.referrer,alert: "Rejected Delivery Request"
    else
      redirect_to request.referrer,alert: 'Some error occured. Please check again!'
    end
  end

  def mark_delivered
    @order = Order.find params[:id]
    if @order.deliver!
      redirect_to request.referrer,notice: 'Successfully Marked Delivered!'
    end
  end

end