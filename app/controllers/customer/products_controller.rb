class Customer::ProductsController < ApplicationController

  include CurrentCart

  before_filter :set_cart

  def home

  end

  def lunch
    @dishes = Dish.where(name: 'lunch').first
  end


end
