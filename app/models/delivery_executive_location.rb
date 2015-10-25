class DeliveryExecutiveLocation < ActiveRecord::Base
  belongs_to :delivery_executive
  belongs_to :location
end
