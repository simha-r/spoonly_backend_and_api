class AddDeliveryFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_fee, :float
  end
end
