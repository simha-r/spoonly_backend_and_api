class Customer::HomesController < Customer::BaseController

  include LocationCheck
  skip_before_filter :detect_android_and_redirect,only: [:android]

  before_action :proceed_to_main_if_old_user

  def main

  end

  def android
  
  end

  def inside
    locality,latitude,longitude,distance = params[:locality],params[:latitude],params[:longitude],params[:distance]

    cookies[:customer] = {value: {location: {locality: locality,latitude: latitude,longitude: longitude,
                                  distance: distance}}.to_json,
                          expires: 1.month.from_now}
    # For parsing it back from cookie
    # values = JSON.parse(cookies[:customer]).with_indifferent_access

    redirect_to [:home,:customer,:menus]
  end

end
