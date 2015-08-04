class Company::BaseController < ApplicationController

  before_filter :authenticate_company_user!,except: [:sms_update]

  def layout_by_resource
    'company_user/application'
  end


  def after_sign_in_path_for(resource)
     company_products_path
  end

  def authenticate_admin!
    redirect_to(company_root_path, alert:'You don not have admin access') unless current_company_user.has_role? :admin
  end

  def authenticate_dispatcher!
    redirect_to(company_root_path, alert:'You don not have dispatcher access') unless (current_company_user.has_role?(:dispatcher) || current_company_user.has_role?(:admin))
  end

  def authenticate_sms_sender!
    redirect_to root_path unless params["secret"]==ENV['TELERIVET_SECRET']
  end

end
