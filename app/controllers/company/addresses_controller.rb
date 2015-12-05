class Company::AddressesController < Company::BaseController

  def index
    @search_term = params[:search_term]
    if @search_term.present?
      wildcard_search = "%#{@search_term}%"
      @addresses = Address.where("address_details iLIKE ? or company iLIKE ? or building iLike ? or flat iLike ? or landmark iLike ?", wildcard_search,wildcard_search,wildcard_search,wildcard_search,wildcard_search).includes(:user).paginate page: params[:page]
    else
      @addresses = Address.order(created_at: :desc).includes(:user).paginate page: params[:page]
    end
  end

  def update
    @address = Address.find params[:id]
    if @address.update_attributes(address_params)
      render 'company/addresses/update'
    else
      render 'company/addresses/failed_update'
    end
  end



  private



  def address_params
    array = params[:latlong].strip.split(',')
    new_params = {}
    new_params[:latitude] = array[0]
    new_params[:longitude] = array[1]
    new_params
  end


end
