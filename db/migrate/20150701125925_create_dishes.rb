class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :desc
      t.string :price
      t.integer :category_id

      t.timestamps
    end
  end
end
