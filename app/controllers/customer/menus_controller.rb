class Customer::MenusController < ApplicationController

  include CurrentCart
  include LocationCheck

  before_filter :check_location
  before_filter :set_cart

  def home
  end

  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    @cart.set_category 'lunch'
    todays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.lunch_order_end_time
      @menu = todays_menu
    else
      @menu = Menu.where(menu_date: Date.tomorrow).first
      @menu_date = Date.tomorrow
    end
  end

  def dinner
    @cart.set_category 'dinner'
    todays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.dinner_order_end_time
      @menu = todays_menu
    else
      @menu = Menu.where(menu_date: Date.tomorrow).first
      @menu_date = Date.tomorrow
    end
  end


end