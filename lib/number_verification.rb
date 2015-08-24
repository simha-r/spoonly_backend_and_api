module NumberVerification

  require 'nexmo'

  def self.start user,number
    user.update_number number
    code = Random.rand(10000..99999).to_s
    user.profile.update_attributes(phone_number_verification_code: code)
    text = "Spoonly code: #{user.profile.phone_number_verification_code}. Valid for 5 minutes."
    SmsProvider.send_message user.profile.phone_number,text
  end

  def self.finish user,code
    tries = user.profile.phone_number_verify_tries.to_i
    user.profile.update_attributes(phone_number_verify_tries: (tries+1))
    if user.profile.phone_number_verification_code == code
      return true
    else
      false
    end
  end

end