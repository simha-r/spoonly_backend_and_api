class Company::Field::OrdersController < Company::Field::BaseController

  def index
    @undelivered_orders = @delivery_executive.orders.where(state: ['informed_delivery_guy','dispatched']).today.order(delivery_time: :asc)
    @delivered_orders = @delivery_executive.orders.where(state: ['delivered']).today.order(delivery_time: :desc)
    if Time.now.hour > 18
      @undelivered_orders = @undelivered_orders.where(category: 'dinner').order(delivery_time: :asc)
      @delivered_orders = @delivered_orders.where(category: 'dinner').order(delivery_time: :asc)
    end
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