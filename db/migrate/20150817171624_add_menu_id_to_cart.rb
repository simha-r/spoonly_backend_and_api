class AddMenuIdToCart < ActiveRecord::Migration
  def change
    add_column :carts, :menu_id, :integer
  end
end
