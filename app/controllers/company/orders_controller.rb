class Company::OrdersController < Company::BaseController


  def index
    @orders = Order.paginate page: params[:page]
  end

   def show
     @order = Order.find params[:id]
   end

end



