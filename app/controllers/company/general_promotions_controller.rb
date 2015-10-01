class Company::GeneralPromotionsController < Company::BaseController
  before_filter :authenticate_admin!
  before_filter :load_resource,except: [:index,:new,:create]

  def index
    @general_promotions = GeneralPromotion.all
  end

  def new
    @general_promotion = GeneralPromotion.new
  end

  def create
    @general_promotion = GeneralPromotion.new(general_promotion_params)
    if @general_promotion.save
      redirect_to [:company,:general_promotions],notice: 'General Promotion has been successfully created'
    end
  end

  def edit
  end

  def update
    if @general_promotion.update_attributes(general_promotion_params)
      redirect_to [:company,:general_promotions],notice: 'General Promotion has been successfully created'
    end
  end

  def enable
    if @general_promotion.enable
      redirect_to request.referrer, notice: 'Promotion has been enabled'
    end
  end

  def disable
    if @general_promotion.disable
      redirect_to request.referrer, notice: 'Promotion has been disabled'
    end
  end


  private

  def general_promotion_params
    params.require(:general_promotion).permit(:name,:amount,:description,:promo_code)
  end

  def load_resource
    @general_promotion = GeneralPromotion.find params[:id]
  end



end
