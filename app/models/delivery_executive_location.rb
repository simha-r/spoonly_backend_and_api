# == Schema Information
#
# Table name: delivery_executive_locations
#
#  id                    :integer          not null, primary key
#  delivery_executive_id :integer
#  location_id           :integer
#  last_seen             :datetime
#  created_at            :datetime
#  updated_at            :datetime
#

class DeliveryExecutiveLocation < ActiveRecord::Base
  belongs_to :delivery_executive
  belongs_to :location
end
