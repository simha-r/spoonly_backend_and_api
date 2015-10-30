module UserMessenger


  def self.order_success order
    user =order.user
    delivery_date = order.delivery_time.to_date
    if delivery_date != Date.current
      message = "Dear #{user.name}, Thank you for using Spoonly. Your order ##{order.id} will be delivered on #{order
      .delivery_time.to_date.strftime("%a,%-d %b")} by #{order.delivery_time_range}."
    else
      message = "Dear #{user.name}, Thank you for using Spoonly. Your order ##{order.id} will be delivered by #{order
      .delivery_time_range}."
    end

    if order.cash_to_pay>0
      message = message+"Please pay Rs #{order.cash_to_pay} to the delivery executive."
    end
    SmsProvider.send_message user.profile.phone_number,message
  end

  def self.apologise user,message
    SmsProvider.send_message user.profile.phone_number,message
  end

  def self.notify_promotion user,promotion
    message = "Welcome to Spoonly. Rs #{promotion.amount} has been credited to your Spoonly wallet. We hope you have a nice meal!"
    SmsProvider.send_message user.profile.phone_number,message
  end

end