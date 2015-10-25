class RemoveLastSeenFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations,:last_seen
    remove_column :locations,:delivery_executive_id
  end
end
