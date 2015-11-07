# == Schema Information
#
# Table name: growth_partners
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  phone_number :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class GrowthPartner < ActiveRecord::Base

  def notify_incentive
    message = "Dear #{name},Incentive has been added to your account."
    SmsProvider.send_message_with_telerivet phone_number,message
  end


end
