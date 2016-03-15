module NumberVerification

  def self.start user,number
    user.update_number number
    code = Random.rand(10000..99999).to_s
    user.profile.update_attributes(phone_number_verification_code: code,number_verification_code_generated_at: Time.now)
    send_code user
  end

  def self.resend user
    last_generated_time = user.profile.number_verification_code_generated_at
    elapsed_time =  last_generated_time ? (Time.now - last_generated_time) : nil
    if(elapsed_time && (elapsed_time > 10.minutes))
      code = Random.rand(10000..99999).to_s
      user.profile.update_attributes(phone_number_verification_code: code,number_verification_code_generated_at: Time.now)
    end
    if !last_generated_time
      user.profile.update_attributes(number_verification_code_generated_at: Time.now)
    end
    send_code user
  end

  def self.send_code user
    text = "Spoonly code: #{user.profile.phone_number_verification_code}. Valid for 5 minutes."
    SmsProvider.delay.send_message_with_infini user.profile.phone_number,text
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