class CreateGrowthPartners < ActiveRecord::Migration
  def change
    create_table :growth_partners do |t|
      t.string :name
      t.string :phone_number

      t.timestamps
    end
  end
end
