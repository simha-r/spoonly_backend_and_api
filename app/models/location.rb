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

  has_many :delivery_executive_locations
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

end