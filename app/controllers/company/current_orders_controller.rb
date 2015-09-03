class Company::CurrentOrdersController < ApplicationController


  def index
    @current_orders = Order.today
  end



end
