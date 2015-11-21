class AddLocationTypeToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :location_type, :string
  end
end
