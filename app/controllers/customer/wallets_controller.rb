class Customer::WalletsController < Customer::BaseController

before_action :authenticate_user!,except: [:recharge]

  def show
    render json: current_user.wallet.balance
  end

  def recharge
    payment_id = params[:payment_id]
    HealthyLunchUtils.log_info "Payment Id is #{payment_id}"

    url = "https://www.instamojo.com/api/1.1/payments/"+payment_id+"/"
    response = Typhoeus.get(url,headers: {'X-Auth-Token'=>ENV['INSTAMOJO_AUTH_TOKEN'],'Accept'=>'application/vnd.spoonly.v1','X-Api-Key'=>ENV['INSTAMOJO_API_KEY']})

    if response.code==200
      response = JSON.parse(response.response_body)
      if response['success']==true
        amount = response['payment']['amount']
        user_id = response['payment']['user_id']
        @user = User.find user_id
        if @user.add_to_wallet amount
          redirect_to successful_recharge_customer_wallet_path
        else
          redirect_to failed_recharge_customer_wallet_path
        end
      end
    end
  end



  def successful_recharge
  end

end