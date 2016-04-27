class AddBufferTimeToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :buffer_time, :integer, default: 1
  end
end
