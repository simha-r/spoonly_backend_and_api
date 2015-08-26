class AddUniquenessToTransactionIdInCardTransaction < ActiveRecord::Migration
  def change
    add_index :card_transactions, [:transaction_id,:payment_gateway], :unique => true
  end
end
