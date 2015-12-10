class AddServingLunchAndServingDinnerToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :serving_lunch, :boolean
    add_column :addresses, :serving_dinner, :boolean
  end
end
