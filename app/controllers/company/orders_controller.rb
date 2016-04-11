class Company::OrdersController < Company::BaseController

  before_filter :authenticate_dispatcher!, except: [:sms_update]
  before_filter :set_order, except: [:index, :sms_update, :by_date, :collections_summary]
  before_filter :authenticate_sms_sender!, only: [:sms_update]

  def index
    @orders = Order.order(delivery_time: :desc).includes(:user).includes(:address).paginate page: params[:page]
  end

  def by_date
    if params[:date]
      @delivery_date = DateTime.new params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i
      @orders = Order.find_by_date @delivery_date
    end
  end

  def show
  end

  def bill
  end

  def acknowledge
    @order.acknowledge!
    redirect_to request.referrer
  end

  def assign
    if @order.update_attributes(order_params)
      @order.dispatch_with order_params[:delivery_executive_id]
      redirect_to [:company, @order], notice: 'Successfully assigned to delivery executive'
    else
      redirect_to [:company, @order], alert: 'Unable to assign'
    end
  end

  def inform_delivery_guy
    @order = Order.find params[:id]
    @delivery_executive = DeliveryExecutive.find params[:inform_delivery_executive_id]
    if @order.inform_delivery_guy @delivery_executive
      redirect_to [:acknowledged,:company,:current_orders],notice: "Informed #{@delivery_executive.name}"
    else
      redirect_to request.referrer,alert: 'Some error occured. Please check again!'
    end
  end

  def withdraw_delivery_request
    @order = Order.find params[:id]
    if @order.withdraw_delivery_request!
      redirect_to [:acknowledged,:company,:current_orders],notice: "Withdrawn Delivery Request"
    else
      redirect_to request.referrer,alert: 'Some error occured. Please check again!'
    end
  end

  def cancel
    if @order.cancel!
      redirect_to [:company, @order]
    end
  end

  def sms_update
    HealthyLunchUtils.log_info "Inside sms update before if loop"
    if params[:secret]==ENV['TELERIVET_SECRET']
      from_number = params['from_number'][3..13]
      if DeliveryExecutive.allowed_numbers.include? from_number
        message = params['content'].strip
        message = message.split(' ')
        order_ids = message[0].split(',')
        HealthyLunchUtils.log_info "Order ids are #{order_ids}"
        if (message[1].downcase=='done') || (message[1].downcase=='d')
          HealthyLunchUtils.log_info "going to find orders #{order_ids} and mark delivered"
          @orders = Order.where id: order_ids
          @orders.where(state: 'dispatched').each(&:deliver!)
          return render nothing: true
        elsif message[1].downcase=='ok'
          HealthyLunchUtils.log_info 'Acknowledged by delivery boy'
          @orders = Order.where id: order_ids
          @orders.where(state: 'informed_delivery_guy').each(&:mark_dispatched!)
          return render nothing: true
        else
          HealthyLunchUtils.log_info 'Wrong format'
          return render nothing: true
        end
      else
        # Got sms from unknown number
        HealthyLunchUtils.log_info "Got sms from unknown number"
        return render nothing: true
      end
    else
      HealthyLunchUtils.log_info "Secret doesnt match telerivet"
      head 403
    end
  rescue Exception => e
    HealthyLunchUtils.log_error 'SMS not in format', e
    return render nothing: true
  end

  def deliver
    if @order.deliver!
      redirect_to request.referrer, notice: 'Order has been marked delivered'
    end
  end

  def collections_summary
    if params[:date]
      @delivery_date = DateTime.new params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i
    else
      @delivery_date = Date.today
    end
    @category = params[:category] || 'lunch'
    @delivered_orders = Order.find_by_date(@delivery_date).includes(:delivery_executive).includes(:debit).includes(:line_items).includes(:user).where.not(state: ['cancelled']).where(category: @category)
  end

  def ask_feedback
    if @order.delivered?
      @order.ask_for_feedback
      redirect_to request.referrer, notice: 'Asked for feedback'
    else
      redirect_to request.referrer, alert: 'Order hasnt been delivered yet'
    end
  end


  def map_view
    @address = @order.address
    if @address.has_location?

      @delivery_executives = DeliveryExecutive.all.select do |d|
        if (d.last_seen_delivery_executive_location)
          if(d.last_seen_delivery_executive_location.last_seen > Time.now - 2.hours)
            distance = d.last_seen_delivery_executive_location.location.distance_from @address.latitude,@address.longitude
          end
        end

      end

      @delivery_hash = @delivery_executives.collect do |de|
        if  de.last_seen_delivery_executive_location
          if @order.delivery_executive == de
             selected_exec = true
          else
            selected_exec = false
          end
          [de.last_seen_delivery_executive_location.location.try(:latitude).try(:to_f),de.last_seen_delivery_executive_location.location.try(:longitude).try(:to_f),de.name,
           de.last_seen_delivery_executive_location.last_seen.strftime("%l:%M %p, %a  %-d %b"),selected_exec,de.id,de.last_seen_delivery_executive_location.location.speed.to_i]
        end
      end.select(&:present?)
      @order_hash = [[@address.latitude.try(:to_f),@address.longitude.try(:to_f),@order.delivery_time_range,@order.user.name,@address.formatted]]
      end
  end


  private

  def order_params
    params.require(:order).permit(:delivery_executive_id)
  end

  def set_order
    @order = Order.find params[:id]
  end

end



