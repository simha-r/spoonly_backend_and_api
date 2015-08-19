class AddDefaultToBalanceInWallet < ActiveRecord::Migration
  def change
    change_column :wallets, :balance, :float, :default => 0
  end
end
