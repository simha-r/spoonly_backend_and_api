class Company::MenuProductsController < Company::BaseController

  def create
    @menu = Menu.find menu_product_params[:menu_id]
    @menu_product = MenuProduct.new menu_product_params
    if @menu_product.save
      redirect_to [:company,@menu], notice: 'Menu Item was successfully added.'
    else
      render action: "new"
    end
  end

  def menu_product_params
    params.require(:menu_product).permit(:product_id,:menu_id,:category)
  end


end