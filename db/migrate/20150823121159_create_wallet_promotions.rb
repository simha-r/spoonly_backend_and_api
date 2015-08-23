class CreateWalletPromotions < ActiveRecord::Migration
  def change
    create_table :wallet_promotions do |t|
      t.string :name
      t.string :description
      t.float :amount

      t.timestamps
    end
  end
end
