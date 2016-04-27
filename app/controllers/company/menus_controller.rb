class Company::MenusController < Company::BaseController

  before_filter :authenticate_admin!
  before_filter :load_resource,except: [:index,:new,:create]


  def index
    @menus = Menu.all
  end

  def show
  end

  def new
    @menu = Menu.new
  end

  def edit
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      redirect_to [:company,@menu], notice: 'menu was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @menu.update_attributes(menu_params)
      redirect_to [:company,@menu], notice: 'menu was successfully updated.'
    else
      render action: "edit"
    end
  end


  def destroy
    @menu.destroy
    redirect_to [:company,:menus] , notice: 'Destroyed menu'
  end

  def notify_users_lunch
    title,message = params[:title],params[:message]
    if !@menu.lunch_notification_sent
      @menu.notify_users_lunch title,message
      @menu.update_attributes(lunch_notification_sent: true)
      redirect_to request.referrer,notice: 'Users will be notified'
    else
      redirect_to request.referrer,alert: 'Already notified! Please check console'
    end
  end

  def notify_users_dinner
    title,message = params[:title],params[:message]
    if !@menu.dinner_notification_sent
      @menu.notify_users_dinner title,message
      @menu.update_attributes(dinner_notification_sent: true)
      redirect_to request.referrer,notice: 'Users will be notified'
    else
      redirect_to request.referrer,alert: 'Already notified! Please check console'
    end
  end

  private

  def load_resource
    @menu = Menu.where(id: params[:id]).first
    redirect_to [:company,:menus], alert: 'Could not find any menu with that id' unless @menu
  end

  def menu_params
    hash = {}
    if params[:menu]["menu_date(1i)"] && params[:menu]["menu_date(2i)"] && params[:menu]["menu_date(3i)"]
      date = Date.new params[:menu]["menu_date(1i)"].to_i, params[:menu]["menu_date(2i)"].to_i,
                      params[:menu]["menu_date(3i)"].to_i
      hash[:menu_date] = date
    end
    hash[:buffer_time] = params[:menu][:buffer_time] || 1
    hash
  end

end
