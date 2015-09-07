class AddSoldOutToMenuProducts < ActiveRecord::Migration
  def change
    add_column :menu_products, :sold_out, :boolean,default: false
  end
end
