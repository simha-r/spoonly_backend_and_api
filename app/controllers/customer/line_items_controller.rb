
class Customer::LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to request.referrer }
        format.js   { @current_item = @line_item }
        format.json { render action: 'show',
                             status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  private


  def line_item_params
    params.require(:line_item).permit(:product_id)
  end
  #...
end
