class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.string :category
      t.timestamps
    end
  end
end
