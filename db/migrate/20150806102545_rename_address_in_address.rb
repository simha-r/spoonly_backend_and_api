class RenameAddressInAddress < ActiveRecord::Migration
  def change
    rename_column :addresses,:address,:address_details
  end
end
