class Company::ProductsController < Company::BaseController

  before_filter :authenticate_admin!
  before_filter :load_resource,except: [:index,:new,:create]


  def index
    @products = Product.all
  end


  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to [:company,@product], notice: 'product was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @product.update_attributes(product_params)
      redirect_to [:company,@product], notice: 'product was successfully updated.'
    else
      render action: "edit"
    end
  end


  def destroy
    @product.destroy
    redirect_to [:company,:products] , notice: 'Destroyed product'
  end

  private

  def load_resource
    @product = Product.where(id: params[:id]).first
    redirect_to [:company,:products], alert: 'Could not find any product with that id' unless @product
  end
  
  def product_params
    params.require(:product).permit(:name,:price,:desc,:state,:photo,:long_description,:vegetarian)
  end


end