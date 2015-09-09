require 'nexmo'

module SmsProvider

  def send_message_with_nexmo phone_number,message
    nexmo = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'], secret: ENV['NEXMO_API_SECRET'])
    nexmo.send_message(from: 'SPOONL', to: "91#{phone_number}", text: message)
  end

  def self.send_message_with_infini phone_number,message
    response = HTTParty.post("http://alerts.solutionsinfini.com/api/v3/index.php",
                  {
                    :query => { "method" => "sms", "api_key" => ENV["INFINI_SMS_API_KEY"],
                                 "to" => "#{phone_number}","sender"=>"SPOONL","message"=>message,
                                 "format"=>"json" }
                  })
    # http://URL/api/v3/index.php?method=sms&api_key=Ad9e5XXXXXXXXXXXXX&to=997XXXXXXX,997XXXXXXX&sender=INFXXX&message=testing&
    #   format=json&custom=1,2&flash=0
  end

  def self.send_message phone_number,message
    self.send_message_with_infini phone_number,message
  end

end