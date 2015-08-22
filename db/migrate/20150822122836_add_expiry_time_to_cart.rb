class AddExpiryTimeToCart < ActiveRecord::Migration
  def change
    add_column :carts, :expiry_time, :datetime
  end
end
