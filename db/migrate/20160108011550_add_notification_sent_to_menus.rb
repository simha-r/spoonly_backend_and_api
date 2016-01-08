class AddNotificationSentToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :notification_sent, :boolean,default: false
  end
end
