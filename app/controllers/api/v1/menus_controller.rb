class Api::V1::MenusController < Api::V1::BaseController

  before_action :authenticate_user!



  def show
    render json: {'lunch'=> {time: '12:15-3:30pm',url: 'menu/lunch'}, 'dinner'=> {'time'=>'7-10pm',
                                                                                   url: 'menu/dinner'}}
  end


  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    if todays_menu = Menu.where(menu_date: Date.today).first
      if Time.now< todays_menu.lunch_order_end_time
        @menu = todays_menu
      else
        @menu = Menu.where(menu_date: Date.tomorrow).first
      end
      render json: @menu.show_lunch
    else
      render json:  {}
    end
  end

  def dinner
    if todays_menu = Menu.where(menu_date: Date.today).firsttodays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.dinner_order_end_time
      @menu = todays_menu
    else
      @menu = Menu.where(menu_date: Date.tomorrow).first
    end
    render json: @menu.show_dinner
    else
      render json:  {}
    end
  end


end
