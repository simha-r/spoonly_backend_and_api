class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.datetime :delivery_time
      t.string :state
      t.string :pay_type
      t.integer :address_id
      t.integer :user_id

      t.timestamps
    end
  end
end
