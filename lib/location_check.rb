module LocationCheck

  def self.serving_region
    @@serving_region ||= Rails.application.config.serving_region
  end

  def self.lunch_serving_region
    @@lunch_serving_region ||= Rails.application.config.lunch_serving_region
  end

  def self.dinner_serving_region
    @@dinner_serving_region ||= Rails.application.config.dinner_serving_region
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
    redirect_to main_customer_homes_path(out_of_service: true) unless proceed
  end

  def self.in_range? lat,long
    serving_region.contains_point? long.to_f,lat.to_f
  end

  def self.in_lunch_range? lat,long
    lunch_serving_region.contains_point? long.to_f,lat.to_f
  end

  def self.in_dinner_range? lat,long
    dinner_serving_region.contains_point? long.to_f,lat.to_f
  end

  def proceed_to_main_if_old_user
    cookies.delete(:customer) if params[:change_location]
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
    redirect_to home_customer_menus_path if proceed
  end

end
