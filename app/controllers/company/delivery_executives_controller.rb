class Company::DeliveryExecutivesController < Company::BaseController

  skip_before_filter :authenticate_company_user!,only:[:update_location]

  def index
    @delivery_executives = DeliveryExecutive.all
  end

  def mark_available
    @delivery_executive = DeliveryExecutive.find params[:id]
    @delivery_executive.mark_available
    redirect_to company_delivery_executives_path,notice: 'Marked available successfully'
  end

  def update_location
    lat,long,id,timestamp=params[:lat],params[:lon],params[:id],params[:timestamp]
    if  delivery_executive = DeliveryExecutive.find_from_tracecar(id)
     delivery_executive.log_location lat,long,timestamp
     head 200
    else
     HealthyLunchUtils.log_info "DeliveryExecutive with traccar id #{id} not found"
     head 200
    end
  end

  def live_view
    @delivery_executives =DeliveryExecutive.all
    @delivery_hash = @delivery_executives.collect do |de|
      if  de.last_seen_delivery_executive_location
        [de.last_seen_delivery_executive_location.location.try(:latitude).try(:to_f),de.last_seen_delivery_executive_location.location.try(:longitude).try(:to_f),de.name,
         de.last_seen_delivery_executive_location.last_seen.strftime("%l:%M %p, %a  %-d %b")]
      end
    end.select(&:present?)
  end

  def show_location
    @delivery_executives = DeliveryExecutive.where(id: params[:id])
    @delivery_hash = @delivery_executives.collect do |de|
      if  de.last_seen_delivery_executive_location
        [de.last_seen_delivery_executive_location.location.try(:latitude).try(:to_f),de.last_seen_delivery_executive_location.location.try(:longitude).try(:to_f),de.name,
         de.last_seen_delivery_executive_location.last_seen.strftime("%l:%M %p, %a  %-d %b")]
      end
    end.select(&:present?)
    render 'company/delivery_executives/live_view'
  end

end