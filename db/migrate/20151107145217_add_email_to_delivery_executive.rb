class AddEmailToDeliveryExecutive < ActiveRecord::Migration
  def change
    add_column :delivery_executives, :email, :string
  end
end
