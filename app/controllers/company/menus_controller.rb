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

  private

  def load_resource
    @menu = Menu.where(id: params[:id]).first
    redirect_to [:company,:menus], alert: 'Could not find any menu with that id' unless @menu
  end

  def menu_params

    date = Date.new params[:menu]["menu_date(1i)"].to_i, params[:menu]["menu_date(2i)"].to_i,
                    params[:menu]["menu_date(3i)"].to_i
    {menu_date: date}

  end
end
