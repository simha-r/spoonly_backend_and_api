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
    @menu = Menu.current_lunch
    if @menu
      render json: @menu.show_lunch
    else
      #TODO Send a notice key value that will be displayed in the app
      render json:  {}
    end
  end

  def dinner
    @menu = Menu.current_dinner
    if @menu
      render json: @menu.show_dinner
    else
      #TODO Send a notice key value that will be displayed in the app
      render json:  {}
    end
  end


end
