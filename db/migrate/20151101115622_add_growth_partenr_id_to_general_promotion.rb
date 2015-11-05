class AddGrowthPartenrIdToGeneralPromotion < ActiveRecord::Migration
  def change
    add_reference :general_promotions, :growth_partner, index: true
  end
end
