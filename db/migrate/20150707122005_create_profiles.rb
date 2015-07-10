class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :phone_number
      t.string :phone_number_verification_req_id
      t.boolean :phone_number_verified
      t.references :user, index: true

      t.timestamps
    end
  end
end
