module DeliveryExecutiveMessenger


  def self.dispatch order
    delivery_executive =order.delivery_executive
    user = order.user
    message = "PH: #{user.profile.phone_number}
    ADDRESS: #{order.address.formatted}
    ORDER \##{order.id}: #{order.formatted_delivery_time}
    #{order.brief_line_items}
    DUE AMOUNT:Rs #{order.cash_to_pay}
    NAME:#{user.name}
    Visit this link to confirm order www.spoonly.in/company/xxxxx.
    Or call 09515407092 to confirm"
    SmsProvider.send_message_with_infini delivery_executive.phone_number,message
  end

  def self.inform_on_field order
    delivery_executive =order.delivery_executive
    user = order.user
    message = "PH: #{user.profile.phone_number}
    ADDRESS: #{order.address.formatted}
    ORDER \##{order.id}: #{order.formatted_delivery_time}
    #{order.brief_line_items}
    DUE AMOUNT:Rs #{order.cash_to_pay}
    NAME:#{user.name}
    Reply #{order.id} ok  to confirm"
    SmsProvider.send_message_with_telerivet delivery_executive.phone_number,message
  end


end
