class Api::V1::MenusController < Api::V1::BaseController

  before_action :authenticate_user!



  def show
    if current_user.promo_code_shown
      show_promo = false
    else
      show_promo = true
      current_user.update_attributes(promo_code_shown: true)
    end
    current_user.log_location params['lat'],params['long']

    hash = {show_promo: show_promo}
    if LocationCheck.in_lunch_range? params['lat'],params['long']
      hash['lunch'] = {time: '12:15 - 3:30 PM',url: 'menu/lunch'}
    end
    if LocationCheck.in_dinner_range? params['lat'],params['long']
      hash['dinner'] = {time: '7:15 - 11:00 PM',url: 'menu/dinner'}
    end

    if hash['lunch'] || hash['dinner']
      render json: hash
    else
      hash = hash.merge({service_unavailable: ENV['OUT_OF_COVERAGE']})
      render json: hash
    end
  end


  #curl -v -H "Accept: application/vnd.healthy_lunch" -H "Content-type: application/application/x-www-form-urlencoded" -H
  # "Authorization:authentication_token"  http://localhost:3000/api/products/lunch
  def lunch 
    @menu = Menu.current_lunch
    if @menu
      render json: @menu.show_lunch
    else
      if [6,7].include? Date.today.wday
        notice = ENV['NOT_SERVING_WEEKEND']
      else
        notice = ENV['NOT_SERVING_WEEKDAY']
      end
      render json: {notice: notice}
    end
  end

  def dinner
    @menu = Menu.current_dinner
    if @menu && @menu.menu_dinner_products.present?
      render json: @menu.show_dinner
    else
      render json: {notice: 'Dinner menu will be uploaded shortly :)'}
    end
  end

end
