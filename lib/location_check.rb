module LocationCheck

  def check_location
    values = JSON.parse(cookies[:customer] || {}.to_json).with_indifferent_access
    proceed = false
    if values[:location]
      if values[:location][:distance].to_f < 10
        proceed = true
      else
        proceed = false
      end
    end
    redirect_to main_customer_homes_path unless proceed
  end


end