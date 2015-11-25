class AddPromotionTypeToWalletPromotions < ActiveRecord::Migration
  def change
    add_column :wallet_promotions, :promotion_type, :string
  end
end
