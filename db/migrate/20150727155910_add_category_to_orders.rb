class AddCategoryToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :category, :string
  end
end
