module DeliveryExecutiveMessenger


  def self.dispatch order
    delivery_executive =order.delivery_executive
    delivery_date = order.delivery_time.to_date

    user = order.user
    message = "PH: #{user.profile.phone_number}
    ADDRESS: #{order.address.formatted}
    ORDER \##{order.id}: #{order.formatted_delivery_time}
    #{order.brief_line_items}
    DUE AMOUNT:Rs #{order.cash_to_pay}
    NAME:#{user.name}
    Visit this link to confirm order www.spoonly.in/company/xxxxx.
    Or call 09515407092 to confirm"

    SmsProvider.send_message delivery_executive.phone_number,message
  end

end
