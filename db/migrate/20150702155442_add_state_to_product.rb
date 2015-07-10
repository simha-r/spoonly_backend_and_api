class AddStateToProduct < ActiveRecord::Migration
  def change
    add_column :products, :state, :string
  end
end
