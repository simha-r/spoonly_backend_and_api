class ChangeNotificationSentToLunchNotificationSentAndDinnerNotificationSent < ActiveRecord::Migration
  def change
    rename_column :menus, :notification_sent, :lunch_notification_sent
    add_column :menus, :dinner_notification_sent, :boolean
  end
end
