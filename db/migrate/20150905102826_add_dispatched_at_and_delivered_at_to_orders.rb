class AddDispatchedAtAndDeliveredAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :dispatched_at, :datetime
    add_column :orders, :delivered_at, :datetime
  end
end
