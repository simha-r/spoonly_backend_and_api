class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address_type
      t.integer :user_id

      t.timestamps
    end
  end
end
