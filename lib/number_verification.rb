module NumberVerification

   def request_verification_for number
     # curl "https://api.nexmo.com/verify/json?api_key={api_key}&api_secret={api_secret}&number=447525856424&brand=MyApp"

   end

  def get_verification_status request_id,code
#     curl "https://api.nexmo.com/verify/check/json?api_key={api_key}&api_secret={api_secret}
# &request_id=8g88g88eg8g8gg9g90&code=123445"
  end


end