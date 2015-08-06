class AddDefaultToisDefaultInAddresses < ActiveRecord::Migration
  def change
    change_column :addresses,:is_default,:boolean,:default=>false
  end
end
