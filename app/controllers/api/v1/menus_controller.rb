class Api::V1::MenusController < Api::V1::BaseController

  before_action :authenticate_user!



  def show
    if LocationCheck.in_range? params['lat'],params['long']
      render json: {'lunch'=> {time: '12:15 - 3:30 PM',url: 'menu/lunch'}, 'dinner'=> {'time'=>'7:00 - 10:00 PM',
                                                                                   url: 'menu/dinner'}}
    else
      head 200
    end
  end


  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    if todays_menu = Menu.where(menu_date: Date.current).first
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
    if todays_menu = Menu.where(menu_date: Date.current).first
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
