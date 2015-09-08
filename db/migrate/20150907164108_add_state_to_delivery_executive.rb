class AddStateToDeliveryExecutive < ActiveRecord::Migration
  def change
    add_column :delivery_executives, :state, :string
  end
end
