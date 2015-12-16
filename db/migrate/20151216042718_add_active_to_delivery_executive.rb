class AddActiveToDeliveryExecutive < ActiveRecord::Migration
  def change
    add_column :delivery_executives, :active, :boolean
  end
end
