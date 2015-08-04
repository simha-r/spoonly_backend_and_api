class Company::OrdersController < Company::BaseController

  before_filter :authenticate_dispatcher!,except: [:sms_update]
  before_filter :set_order,except: [:index,:sms_update]
  before_filter :authenticate_sms_sender!,only: [:sms_update]

  def index
    @orders = Order.paginate page: params[:page]
  end

  def show
  end

  def acknowledge
    @order.acknowledge!
    redirect_to [:company,@order]
  end

  def assign
    if @order.update_attributes(order_params)
      @order.dispatch!
      redirect_to [:company,@order], notice: 'Successfully assigned to delivery executive'
    else
      redirect_to [:company,@order],alert: 'Unable to assign'
    end
  end

  def sms_update
    if DeliveryExecutive.allowed_numbers.include? params['contact']['from_number']
      message = params['content'].strip
      message = message.split(' ')
      order_ids = message[1]
      if message[0].downcase=='sp'
        @orders = Order.find order_ids
        @orders.collect(&:deliver!)
        return render nothing: true
      else
        return
      end
    else
      puts params
      return
    end
  rescue Exception=>e
    HealthyLunchUtils.log_error 'SMS not in format',e
  end

  private

  def order_params
    params.require(:order).permit(:delivery_executive_id)
  end

  def set_order
    @order = Order.find params[:id]
  end

end



