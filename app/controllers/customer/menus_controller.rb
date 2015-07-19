class Customer::MenusController < ApplicationController

  include CurrentCart

  before_filter :set_cart


  def home

  end


  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    todays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.lunch_order_end_time
      @menu = todays_menu
    else
      @menu = Menu.where(menu_date: Date.tomorrow).first
    end

  end

  def dinner
    todays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.dinner_order_end_time
      @menu = todays_menu
    else
      @menu = Menu.where(menu_date: Date.tomorrow).first
    end
  end

end
