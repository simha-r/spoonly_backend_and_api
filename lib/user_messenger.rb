module UserMessenger


  def self.order_success order
    user =order.user
    message = "Dear #{user.name}, Thank you for using Spoonly. Your order ##{order.id} will be delivered by #{order
    .delivery_time_range}."
    if order.cash_to_pay>0
      message = message+"Please pay Rs #{order.cash_to_pay} to the delivery executive."
    end
    SmsProvider.send_message user.profile.phone_number,message
  end


end