class AddLatitiudeAndLongitudeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :latitude, :decimal
    add_column :addresses, :longitude, :decimal
  end
end
