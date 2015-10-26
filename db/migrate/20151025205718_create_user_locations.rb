class CreateUserLocations < ActiveRecord::Migration
  def change
    create_table :user_locations do |t|
      t.datetime :last_seen
      t.references :user, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
