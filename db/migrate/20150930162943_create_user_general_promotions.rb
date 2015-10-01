class CreateUserGeneralPromotions < ActiveRecord::Migration
  def change
    create_table :user_general_promotions do |t|
      t.references :user, index: true
      t.references :general_promotion, index: true

      t.timestamps
    end
  end
end
