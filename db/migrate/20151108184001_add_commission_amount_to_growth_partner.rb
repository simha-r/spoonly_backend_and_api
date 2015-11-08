class AddCommissionAmountToGrowthPartner < ActiveRecord::Migration
  def change
    add_column :growth_partners, :commission_amount, :float
  end
end
