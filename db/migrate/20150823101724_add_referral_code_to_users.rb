class AddReferralCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referral_code, :string,unique: true
  end
end
