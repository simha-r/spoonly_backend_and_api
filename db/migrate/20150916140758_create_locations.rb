class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal :latitude,{:precision=>10, :scale=>6}
      t.decimal :longitude,{:precision=>10, :scale=>6}
      t.datetime :last_seen
      t.references :delivery_executive

      t.timestamps
    end
  end
end
