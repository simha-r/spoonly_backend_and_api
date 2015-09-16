# == Schema Information
#
# Table name: locations
#
#  id                    :integer          not null, primary key
#  latitude              :decimal(10, 6)
#  longitude             :decimal(10, 6)
#  last_seen             :datetime
#  delivery_executive_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#

class Location < ActiveRecord::Base
  belongs_to :delivery_executive
end
