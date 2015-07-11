class Api::V1::ProductsController < Api::V1::BaseController

  before_action :authenticate_user!

  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch

end
