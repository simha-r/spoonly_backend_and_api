module LocationCheck

  def check_location
    proceed = false
    if cookies[:customer]
      values = JSON.parse(cookies[:customer] || {}.to_json).with_indifferent_access
      if values[:location]
        if values[:location][:distance].to_f < 10
          proceed = true
        end
      end
    end
    redirect_to main_customer_homes_path unless proceed
  end


end