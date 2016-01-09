class Company::MenuProductsController < Company::BaseController

  before_filter :authenticate_admin!

  def create
    @menu = Menu.find menu_product_params[:menu_id]
    @menu_product = MenuProduct.new menu_product_params
    if @menu_product.save
      redirect_to [:company,@menu], notice: 'Menu Item was successfully added.'
    else
      render action: "new"
    end
  end

  def destroy
    @menu_product = MenuProduct.find params[:id]
    @menu_product.destroy
    redirect_to request.referrer,notice: 'Item has been removed from the Menu'
  end

  def mark_sold_out
    @menu_product = MenuProduct.find params[:id]
    if @menu_product.update_attributes(sold_out: true)
      redirect_to request.referrer,notice: 'Successfully marked sold out'
    end
  end

  def unmark_sold_out
    @menu_product = MenuProduct.find params[:id]
    if @menu_product.update_attributes(sold_out: false)
      redirect_to request.referrer,notice: 'Successfully marked NOT Sold out'
    end
  end


  private

  def menu_product_params
    params.require(:menu_product).permit(:product_id,:menu_id,:category,:max_quantity)
  end


end