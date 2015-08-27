module LocationCheck

  def self.serving_region
    @@serving_region ||= Rails.application.config.serving_region
  end

  def check_location
    proceed = false
    if cookies[:customer]
      values = JSON.parse(cookies[:customer] || {}.to_json).with_indifferent_access
      if values[:location]
        if LocationCheck.in_range? values[:location][:latitude],values[:location][:longitude]
        # if values[:location][:distance].to_f < 10
          proceed = true
        end
      end
    end
    redirect_to main_customer_homes_path unless proceed
  end

  def self.in_range? lat,long
    serving_region.contains_point? long.to_f,lat.to_f
  end


end