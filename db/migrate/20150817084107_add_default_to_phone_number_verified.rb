class AddDefaultToPhoneNumberVerified < ActiveRecord::Migration
  def change
    change_column :profiles, :phone_number_verified, :boolean, :default => false
  end
end
