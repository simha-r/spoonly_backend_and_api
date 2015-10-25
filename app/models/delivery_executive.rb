# == Schema Information
#
# Table name: delivery_executives
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  phone_number :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  state        :string(255)
#

class DeliveryExecutive < ActiveRecord::Base


  has_many :orders
  has_many :locations,through: :delivery_executive_locations
  has_many :delivery_executive_locations

  scope :available,->{where(state: 'available')}
  scope :out_for_delivery, ->{where(state: 'available')}

  def delivered_orders
    orders.where(state: 'delivered')
  end

  def self.allowed_numbers
    DeliveryExecutive.all.collect(&:phone_number) + ['+918179422804','+919618347300']
  end

  def mark_out_for_delivery
    update_attributes!(state: 'out_for_delivery')
  end

  def mark_available
    update_attributes!(state: 'available')
  end

  def not_available?
    state != 'available'
  end

  def last_seen_delivery_executive_location
    delivery_executive_locations.order(last_seen: :asc).includes(:location).last
  end

  def log_location lat,long,timestamp
    last_seen = Time.at(timestamp.to_f).to_datetime
    location= Location.create(latitude: lat.to_f,longitude: long.to_f)
    if location.persisted?
      delivery_executive_locations.create(last_seen: last_seen,location: location)
    end
  end

  def self.find_from_tracecar id
    where(phone_number: id).first
  end

end
