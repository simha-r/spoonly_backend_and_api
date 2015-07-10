class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.references :user, index: true
      t.float :balance

      t.timestamps
    end
  end
end
