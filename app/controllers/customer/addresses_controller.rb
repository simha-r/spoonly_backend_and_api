class Customer::AddressesController < Customer::BaseController


  before_filter :set_address,except: [:index,:create]

  def create
    @address = current_user.addresses.build(address_params)
    if @address.save
      render 'create'
    else
      render json: @address.errors,status: 422
    end
  end

  def index
    render json: {default: [current_user.addresses.default_home, current_user.addresses.default_office].compact!,
                  home: current_user.addresses.normal_home, office: current_user.addresses.normal_office}
  end

  def update
    if @address.update_attributes address_params
      render json: @address
    else
      render json: @address.errors,status: 422
    end
  end

  def destroy
    @address.destroy
    render nothing: true,status: :ok,content_type: 'application/json'
  end


  private

  def address_params
     params.permit(:company,:floor,:building,:address,:flat,:address_details,:landmark,:address_type,:is_default)
  end

  def set_address
    @address = current_user.addresses.find params[:id]
  end

end