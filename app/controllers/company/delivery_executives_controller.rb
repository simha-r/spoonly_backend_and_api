class Company::DeliveryExecutivesController < Company::BaseController

  skip_before_filter :authenticate_company_user!,only:[:update_location]
  before_filter :set_delivery_executive,only: [:edit,:update,:test_device]
  before_filter :authenticate_admin!,except: [:index,:mark_available,:show_location,:live_view,:update_location,:test_device]

  def index
    @delivery_executives = DeliveryExecutive.all
  end

  def dashboard
    @delivery_executives = DeliveryExecutive.all
  end

  def test_device
    if @delivery_executive.test_device
      redirect_to request.referrer,notice: 'Sent alarm to device. Check if it rings'
    end
  end

  def new
    @delivery_executive = DeliveryExecutive.new
  end

  def create
    if @delivery_executive = DeliveryExecutive.create(delivery_executive_params)
      redirect_to [:company,:delivery_executives], notice: 'Successfuly created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @delivery_executive.update_attributes(delivery_executive_params)
      redirect_to [:company,:delivery_executives], notice: 'Successfuly updated'
    else
      render :edit
    end
  end

  def mark_available
    @delivery_executive = DeliveryExecutive.find params[:id]
    @delivery_executive.mark_available
    redirect_to company_delivery_executives_path,notice: 'Marked available successfully'
  end

  def update_location
    lat,long,id,speed,timestamp=params[:lat],params[:lon],params[:id],params[:speed],params[:timestamp]
    if  delivery_executive = DeliveryExecutive.find_from_tracecar(id)
     delivery_executive.log_location lat,long,speed,timestamp
     head 200
    else
     HealthyLunchUtils.log_info "DeliveryExecutive with traccar id #{id} not found"
     head 200
    end
  end

  def live_view
    @delivery_executives =DeliveryExecutive.active
    @delivery_hash = @delivery_executives.collect do |de|
      if  de.last_seen_delivery_executive_location
        if de.last_seen_delivery_executive_location.last_seen > Time.now - 2.hours
          [de.last_seen_delivery_executive_location.location.try(:latitude).try(:to_f),de.last_seen_delivery_executive_location.location.try(:longitude).try(:to_f),de.name,
           de.last_seen_delivery_executive_location.last_seen.strftime("%l:%M %p, %a  %-d %b"),de.id,de.last_seen_delivery_executive_location.location.speed.to_i]
        end
      end
    end.select(&:present?)
  end

  def show_location
    @delivery_executive = DeliveryExecutive.find params[:id]
    @delivery_executives = DeliveryExecutive.where(id: params[:id])
    @delivery_hash = @delivery_executives.collect do |de|
      if  de.last_seen_delivery_executive_location
        [de.last_seen_delivery_executive_location.location.try(:latitude).try(:to_f),de.last_seen_delivery_executive_location.location.try(:longitude).try(:to_f),de.name,
         de.last_seen_delivery_executive_location.last_seen.strftime("%l:%M %p, %a  %-d %b")]
      end
    end.select(&:present?)
    render 'company/delivery_executives/live_view'
  end


  private

  def delivery_executive_params
    params.require(:delivery_executive).permit(:name,:phone_number)
  end

  def set_delivery_executive
   @delivery_executive =  DeliveryExecutive.find params[:id]
  end

end