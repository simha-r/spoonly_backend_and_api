class AddSpeedToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :speed, :float
  end
end
