class AddActiveToGeneralPromotions < ActiveRecord::Migration
  def change
    add_column :general_promotions, :active, :boolean, default: false
  end
end
