module Api::V1::SessionsHelper


  def get_user_info access_token,provider

    if provider=='facebook'
      graph = Koala::Facebook::API.new(access_token)
      profile = graph.get_object("me")
      @picture = graph.get_picture("me")
      @email = profile['email']
      @uid = profile['id']
      @name = profile['name']
    elsif provider=='google'
      #TODO get email and uid
      response = HTTParty.get("https://www.googleapis.com/oauth2/v2/userinfo",
                              headers: {"Access_token"  => access_token,
                                        "Authorization" => "OAuth #{access_token}"})
      if response.code == 200
        response = JSON.parse(response.body)
        @email = response['email']
        @uid = response['id']
        @name = response['name']
        @picture = response['picture']
      end
    end
    if !@email.present?
      raise 'Error getting user info from'+provider.to_s
    end
    return true
  rescue Exception=>e
    HealthyLunchUtils.log_error e.message,e
    return false
  end

=begin
  def verify_access_token
    url = '/app'
    data = {"access_token"=>params[:access_token]}
    b = get_data SocialAccount::FACEBOOK_URL, url, data
    if b.success?
      body = b.body
      unless((body["name"]=='DealMobMock') || (body["name"]=='Testmob'))
        raise 'Access token doesnt belong to our app'
      end
    else
      raise 'Validating FB token resulted in error/forbidden'
    end
  end
=end

end