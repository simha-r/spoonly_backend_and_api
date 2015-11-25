class AddShownPromoCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :promo_code_shown, :boolean
  end
end
