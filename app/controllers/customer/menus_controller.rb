class Customer::MenusController < ApplicationController

  include CurrentCart
  include LocationCheck

  before_filter :check_location
  before_filter :set_cart
  before_filter :set_locality, only: [:home, :lunch, :dinner]


  def home
  end

  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    @menu = Menu.current_lunch
    @cart.set_menu_and_category @menu,'lunch'
  end

  def dinner
    @menu = Menu.current_dinner
    @cart.set_menu_and_category @menu,'dinner'
  end

  private
    def set_locality
      location_hash = JSON.parse cookies[:customer]
      full_locality  = location_hash["location"]["locality"]
      # eg: ["DLF Cyber City", " Gachibowli", " Hyderabad", " Telangana", " India"]
      # DLF Cyber City  Gachibowli
      @locality = full_locality.split(',')[0,2].join(',')
    end
end
