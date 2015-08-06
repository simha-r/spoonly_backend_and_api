class RenameDefaultToDefaultAddress < ActiveRecord::Migration
  def change
    rename_column :addresses,:default,:is_default
  end
end
