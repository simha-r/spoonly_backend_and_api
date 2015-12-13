class AddOrdersCountToUsers < ActiveRecord::Migration

  def self.up

    add_column :users, :orders_count, :integer, :null => false, :default => 0
    Order.counter_culture_fix_counts
  end

  def self.down

    remove_column :users, :orders_count

  end

end
