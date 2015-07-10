class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :product_name
      t.integer :product_id
      t.integer :order_id
      t.integer :cart_id
      t.float :price
      t.integer :quantity,:default => 1

      t.timestamps
    end
  end
end
