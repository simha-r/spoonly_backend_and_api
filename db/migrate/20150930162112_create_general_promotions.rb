class CreateGeneralPromotions < ActiveRecord::Migration
  def change
    create_table :general_promotions do |t|
      t.string :promo_code
      t.string :name
      t.string :description
      t.string :amount

      t.timestamps
    end
  end
end
