class AddDeliveryExecutiveIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_executive_id, :integer
  end
end
