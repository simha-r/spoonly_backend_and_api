class Customer::NumberVerificationsController < Customer::BaseController

  before_action :authenticate_user!


  # POST /api/number_verifications params {phone_number: 98989898898}
  def start_verification_request
    # NumberVerification.request_verification_for params[:phone_number]
  end

  # POST /api/number_verifications params {code: 4567}
  def end_verification_request
    # NumberVerification.get_verification_status current_user.profile.phone_number_verification_req_id,
    #                                            params[:verification_code]

    respond_to do |format|
      format.js {render 'customer/orders/show_final'}
    end
  end


end