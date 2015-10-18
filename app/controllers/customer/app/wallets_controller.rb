class Customer::App::WalletsController < Customer::App::BaseController

  require 'typhoeus'

  def recharge
    #This url can be refreshed to...so customer may add same money multiple times...store payment_id in wallet
    # record and then check if already present
    payment_id = params[:payment_id]
    url = "https://www.instamojo.com/api/1.1/payments/"+payment_id+"/"
    response = ::Typhoeus.get(url,headers: {'X-Auth-Token'=>ENV['INSTAMOJO_AUTH_TOKEN'],'X-Api-Key'=>ENV['INSTAMOJO_API_KEY']})

    if response.code==200
      response = JSON.parse(response.response_body)
      if response['success']==true
        amount = response['payment']['amount']
        user_id = response['payment']['custom_fields']['Field_96618']['value']
        @user = User.find user_id
        if @user.add_to_wallet amount,payment_id,'instamojo'
         return redirect_to successful_recharge_customer_app_wallet_path
        else
          return redirect_to failed_recharge_customer_app_wallet_path
        end
      end
    end
    redirect_to failed_recharge_customer_app_wallet_path
  end



  def successful_recharge

  end

  def failed_recharge

  end

end