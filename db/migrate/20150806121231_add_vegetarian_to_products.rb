class AddVegetarianToProducts < ActiveRecord::Migration
  def change
    add_column :products, :vegetarian, :boolean,default: false
  end
end
