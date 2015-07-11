class Api::V1::ProductsController < Api::V1::BaseController

  before_action :authenticate_user!

  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    @category = Category.where(name: 'lunch').first
    products = @category.products.active
    render json: @category.products
  end

  def index

    if params[:distance].to_i < Product::SERVING_RADIUS
      @lunch_category = Category.where(name: 'lunch').first
      lunch_products = @lunch_category.products.active
    end

    products = {}
    products[:lunch]={start_time: @lunch_category.start_time,end_time:  @lunch_category.end_time,
                      products: lunch_products}


    render json: {}




  end


end
