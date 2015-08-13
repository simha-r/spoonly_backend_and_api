class Customer::NumberVerificationsController < Customer::BaseController

  before_action :authenticate_user!


  # POST /api/number_verifications params {phone_number: 98989898898}
  def start
    response = NumberVerification.start current_user,params[:phone_number]
    if response
      respond_to do |format|
        format.js { render :file => "customer/number_verifications/start_verification_request.js" }
      end
    else
      head 422,content_type: 'application/json'
    end
  end

  # POST /api/number_verifications params {code: 4567}
  #def finish
    #if NumberVerification.finish current_user,params[:verification_code]
      #current_user.mark_number_verified
      #respond_to do |format|
        #format.js {render 'customer/orders/show_final'}
      #end
    #else
      #respond_to do |format|
        #format.js {render 'customer/orders/wrong_code'}
      #end
    #end
  #end

  def finish
    if NumberVerification.finish current_user,params[:verification_code]
      current_user.mark_number_verified
      redirect_to new_customer_order_path(:menu_date => params[:menu_date])
    else
      redirect_to new_customer_order_path(:menu_date => params[:menu_date]),alert: 'Please enter the correct
verification code'
    end
  end

end
