class Company::BaseController < ApplicationController

  before_filter :authenticate_company_user!

  def layout_by_resource
    'company_user/application'
  end


  def root_path
    company_products_path
  end

  def after_sign_in_path_for(resource)
     company_products_path
  end

end
