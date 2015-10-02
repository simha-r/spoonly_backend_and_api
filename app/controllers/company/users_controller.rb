class Company::UsersController < ApplicationController

  before_filter :load_resource, except: [:index]

  def index
    @users = User.paginate page: params[:page]
  end

  def show

  end

  private

  def load_resource
    @user =User.find params[:id]
  end

end