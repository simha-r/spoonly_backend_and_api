class AddUniquenessToMenuProduct < ActiveRecord::Migration
  def change
    add_index :menu_products, [:product_id,:menu_id,:category], :unique => true
  end
end
