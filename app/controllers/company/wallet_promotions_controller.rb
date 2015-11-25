class Company::WalletPromotionsController < Company::BaseController
  before_filter :authenticate_admin!
  before_filter :load_resource,except: [:index,:new,:create]

  def index
    @wallet_promotions = WalletPromotion.all
  end

  def new
    @wallet_promotion = WalletPromotion.new
  end

  def create
    @wallet_promotion = WalletPromotion.new(wallet_promotion_params)
    if @wallet_promotion.save
      redirect_to [:company,:wallet_promotions],notice: 'General Promotion has been successfully created'
    end
  end

  def show

  end

  def edit
  end

  def update
    if @wallet_promotion.update_attributes(wallet_promotion_params)
      redirect_to [:company,:wallet_promotions],notice: 'General Promotion has been successfully created'
    end
  end

  def enable
    if @wallet_promotion.enable
      redirect_to request.referrer, notice: 'Promotion has been enabled'
    end
  end

  def disable
    if @wallet_promotion.disable
      redirect_to request.referrer, notice: 'Promotion has been disabled'
    end
  end


  private

  def wallet_promotion_params
    params.require(:wallet_promotion).permit(:name,:amount,:description,:promotion_type)
  end

  def load_resource
    @wallet_promotion = WalletPromotion.find params[:id]
  end



end
