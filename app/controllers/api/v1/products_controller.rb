class Api::V1::ProductsController < Api::V1::BaseController

  before_action :authenticate_user!

  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/json" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    @category = Category.where(name: 'lunch').first
    products = @category.products.active
    render json: @category.products
  end


end
