class CreateDeliveryExecutiveLocations < ActiveRecord::Migration
  def change
    create_table :delivery_executive_locations do |t|
      t.references :delivery_executive, index: true
      t.references :location, index: true
      t.datetime :last_seen

      t.timestamps
    end
  end
end
