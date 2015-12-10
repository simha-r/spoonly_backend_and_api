# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  address_type    :string(255)
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  company         :string(255)
#  floor           :string(255)
#  building        :string(255)
#  flat            :string(255)
#  landmark        :string(255)
#  address_details :string(255)
#  is_default      :boolean          default(FALSE)
#  latitude        :decimal(, )
#  longitude       :decimal(, )
#  serving_lunch   :boolean
#  serving_dinner  :boolean
#

class Address < ActiveRecord::Base

  belongs_to :user

  def self.office
    where(address_type: 'office')
  end

  def self.home
    where(address_type: 'home')
  end

  def self.normal_office
    where(address_type: 'office', is_default: false)
  end

  def self.normal_home
    where(address_type: 'home', is_default: false)
  end

  def self.default_office
    where(address_type: 'office', is_default: true).first
  end

  def self.default_home
    where(address_type: 'home', is_default: true).first
  end

  validates :address_type, presence: true, inclusion: {in: ['home', 'office']}

  before_save :set_serving_categories
  before_save :make_default_if_initial
  before_save :undefault_other_addresses, :if => Proc.new { |address| address.is_default }


  def make_default_if_initial
    if address_type=='home'
      unless user.addresses.home.present?
        make_default!
      end
    else
      unless user.addresses.office.present?
        make_default!
      end
    end
  end

  def make_default!
    update_attribute(:is_default, true) unless is_default
  end

  def undefault_other_addresses
    if address_type=='office'
      other_addresses = user.addresses.office - [self]
    elsif address_type=='home'
      other_addresses = user.addresses.home - [self]
    end
    other_addresses.each do |address|
      address.update_attribute(:is_default, false)
    end
  end

  def serializable_hash(options={})
    options ||={}
    options[:except] ||= [:user_id, :updated_at, :created_at]
    super
  end

  def formatted
    if address_type=='home'
      address= ""
      if flat.present?
        address=address + " Flat: #{flat},"
      end
      if building.present?
        address=address + " Bldg: #{building},"
      end

      if address_details.present?
        address=address + "#{address_details}"
      end

      if landmark.present?
        address=address + ",#{landmark}"
      end
    else
      address = "#{company},"
      if floor.present?
        address=address + " Fl: #{floor},"
      end
      if building.present?
        address=address + " Bldg: #{building},"
      end
      if address_details.present?
        address=address + "#{address_details}"
      end
      if landmark.present?
        address=address + ", Landmark: #{landmark}"
      end
    end
    address
  end

  def has_location?
    latitude.present? and longitude.present?
  end

  def set_serving_categories
    if latitude.present? and longitude.present?
      if LocationCheck.in_lunch_range? latitude,longitude
        self.serving_lunch = true
      end
      if LocationCheck.in_dinner_range? latitude,longitude
        self.serving_dinner = true
      end
    end
  end

  def set_serving_categories!
    set_serving_categories
    save
  end


end
