class CreateDeliveryExecutives < ActiveRecord::Migration
  def change
    create_table :delivery_executives do |t|
      t.string :name
      t.string :phone_number

      t.timestamps
    end
  end
end
