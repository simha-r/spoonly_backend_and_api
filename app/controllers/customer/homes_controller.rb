class Customer::HomesController < ApplicationController

  before_filter :authenticate_user!

  def main

  end


  def inside
    redirect_to [:home,:customer,:products]
  end

end
