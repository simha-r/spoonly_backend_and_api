class CreateCardTransactions < ActiveRecord::Migration
  def change
    create_table :card_transactions do |t|
      t.string :transaction_id
      t.string :amount
      t.string :payment_gateway

      t.timestamps
    end
  end
end
