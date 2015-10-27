module DeliveryExecutiveMessenger


  def self.dispatch order
    delivery_executive =order.delivery_executive
    user = order.user
    message = "#{user.name[0..10]},#{user.profile.phone_number}
#{order.address.formatted}.
##{order.id}: #{order.sms_formatted_delivery_time}
#{order.brief_line_items}
Rs #{order.cash_to_pay.to_i}"
    HealthyLunchUtils.log_info "Sending message to #{delivery_executive.name}"
    SmsProvider.send_message_with_telerivet delivery_executive.phone_number,message
  end

  def self.inform_on_field order
    delivery_executive =order.delivery_executive
    user = order.user
    message = "#{user.name[0..10]},#{user.profile.phone_number}
#{order.address.formatted}.
##{order.id}: #{order.sms_formatted_delivery_time}
#{order.brief_line_items}
Rs #{order.cash_to_pay.to_i}
Rply #{order.id} ok"
    HealthyLunchUtils.log_info "Sending message to #{delivery_executive.name}"
    SmsProvider.send_message_with_telerivet delivery_executive.phone_number,message
  end


end
