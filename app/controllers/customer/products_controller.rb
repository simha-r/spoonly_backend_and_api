class Customer::ProductsController < ApplicationController

  include CurrentCart

  before_filter :set_cart

  def home

  end

  def lunch
    @category = Category.where(name: 'lunch').first
  end


end
