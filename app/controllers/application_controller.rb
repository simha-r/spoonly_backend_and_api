class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  layout :layout_by_resource


  def store_specific_location url
    session[:previous_url] = url
  end

  def after_sign_in_path_for(resource)
    if resource.class==User
      session[:previous_url] || root_path
    else
      company_root_path
    end
  end


  def layout_by_resource
    'user/application'
  end


end
