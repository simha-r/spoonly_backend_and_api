class AddReferralsCountToUsers < ActiveRecord::Migration

  def self.up
    add_column :users, :referrals_count, :integer, :null => false, :default => 0
    Referral.counter_culture_fix_counts
  end

  def self.down

    remove_column :users, :referrals_count

  end

end
