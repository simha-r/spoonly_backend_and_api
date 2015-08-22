class CreateDebits < ActiveRecord::Migration
  def change
    create_table :debits do |t|
      t.references :wallet, index: true
      t.float :amount
      t.string :latest_wallet_balance
      t.references :order, index: true

      t.timestamps
    end
  end
end
