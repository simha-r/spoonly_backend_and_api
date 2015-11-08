class Company::GrowthPartnersController < Company::BaseController
  before_filter :authenticate_admin!
  before_filter :load_resource,except: [:index,:new,:create]

  def index
    @growth_partners = GrowthPartner.all
  end

  def new
    @growth_partner = GrowthPartner.new
  end

  def show

  end


  def create
    @growth_partner = GrowthPartner.new(growth_partner_params)
    if @growth_partner.save
      redirect_to [:company,:growth_partners],notice: 'Growth Partner has been successfully created'
    end
  end

  def edit
  end

  def update
    if @growth_partner.update_attributes(growth_partner_params)
      redirect_to [:company,:growth_partners],notice: 'Growth Partner has been successfully updated'
    end
  end



  private

  def growth_partner_params
    params.require(:growth_partner).permit(:name,:phone_number,:commission_amount)
  end

  def load_resource
    @growth_partner = GrowthPartner.find params[:id]
  end



end
