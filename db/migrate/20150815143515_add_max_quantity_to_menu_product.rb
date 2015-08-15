class AddMaxQuantityToMenuProduct < ActiveRecord::Migration
  def change
    add_column :menu_products, :max_quantity, :integer
  end
end
