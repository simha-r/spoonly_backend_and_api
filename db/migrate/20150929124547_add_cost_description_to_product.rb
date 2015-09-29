class AddCostDescriptionToProduct < ActiveRecord::Migration
  def change
    add_column :products, :cost_description, :text
  end
end
