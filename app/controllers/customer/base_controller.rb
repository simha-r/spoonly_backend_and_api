class Customer::BaseController < ApplicationController


  before_filter :detect_android_and_redirect

  protected

  def detect_android_and_redirect
    # redirect_to android_customer_homes_path if android?
  end

  def android?
    request.user_agent =~ /Android/i
  end


end