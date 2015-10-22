class Api::V1::MenusController < Api::V1::BaseController

  before_action :authenticate_user!



  def show
    if LocationCheck.in_range? params['lat'],params['long']
      # render json: {'lunch'=> {time: '12:15 - 3:30 PM',url: 'menu/lunch'}, 'dinner'=> {'time'=>'7:00 - 10:00 PM',
      #                                                                              url: 'menu/dinner'}}
      render json: {'lunch'=> {time: '12:15 - 3:30 PM',url: 'menu/lunch'}}
    else
      render json: {service_unavailable: "<html><body>We currently do not serve in your area<br />We currently serve in parts of Hitech City & Gachibowli</body></html>"}
    #TODO Send html to show on client...like We currently dont serve in your area. We serve in selected parts of
    # Hitech City and gachibowli
    end
  end


  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch
    @menu = Menu.current_lunch
    if @menu
      render json: @menu.show_lunch
    else
      if [5,6,7].include? Date.today.wday
        notice = ENV['NOT_SERVING_WEEKEND']
      else
        notice = ENV['NOT_SERVING_WEEKDAY']
      end
      render json: {notice: notice}
    end
  end

  def dinner
    @menu = Menu.current_dinner
    if @menu
      render json: @menu.show_dinner
    else
      render json: {notice: 'We are closed today. Please check again tomorrow !'}
    end
  end


end
