class Customer::LineItemsController < Customer::BaseController
  include CurrentCart
  before_action :set_cart

  # POST /line_items
  # POST /line_items.json
  def create
    @menu_product = MenuProduct.find(params[:menu_product_id])
    @line_item = @cart.add_menu_product(@menu_product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to request.referrer }
        format.js   { render 'update.js' }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  def decrease_count
    @line_item = @cart.line_items.find params[:id]
    respond_to do |format|
      if @line_item.decrement_count
        format.html { redirect_to request.referrer }
        format.js   { render 'update.js' }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  private


  def line_item_params
    params.require(:line_item).permit(:menu_product_id)
  end
  #...
end
