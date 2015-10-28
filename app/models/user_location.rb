# == Schema Information
#
# Table name: user_locations
#
#  id          :integer          not null, primary key
#  last_seen   :datetime
#  user_id     :integer
#  location_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class UserLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
end
