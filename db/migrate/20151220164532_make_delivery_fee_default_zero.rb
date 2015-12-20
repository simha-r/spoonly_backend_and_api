class MakeDeliveryFeeDefaultZero < ActiveRecord::Migration
  def change
    change_column_default(:orders, :delivery_fee, 0)
  end
end
