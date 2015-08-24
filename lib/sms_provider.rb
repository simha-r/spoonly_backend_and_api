require 'nexmo'

module SmsProvider

  def self.send_message phone_number,message
    nexmo = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'], secret: ENV['NEXMO_API_SECRET'])
    nexmo.send_message(from: 'SPOONL', to: "91#{phone_number}", text: message)
  end

end