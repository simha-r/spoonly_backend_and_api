class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :wallet, index: true
      t.float :amount
      t.string :latest_wallet_balance
      t.string :credit_type
      t.integer :payment_mechanism_id
      t.string :payment_mechanism_type

      t.timestamps
    end
  end
end
