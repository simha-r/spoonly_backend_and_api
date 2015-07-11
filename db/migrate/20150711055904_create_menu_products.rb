class CreateMenuProducts < ActiveRecord::Migration
  def change
    create_table :menu_products do |t|
      t.references :menu, index: true
      t.references :product, index: true
      t.string :category

      t.timestamps
    end
  end
end
