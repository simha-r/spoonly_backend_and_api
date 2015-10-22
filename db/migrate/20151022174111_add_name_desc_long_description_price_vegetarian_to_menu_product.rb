class AddNameDescLongDescriptionPriceVegetarianToMenuProduct < ActiveRecord::Migration
  def change
    add_column :menu_products, :name, :string
    add_column :menu_products, :desc, :string
    add_column :menu_products, :long_description, :string
    add_column :menu_products, :price, :float
    add_column :menu_products, :vegetarian, :boolean
  end
end
