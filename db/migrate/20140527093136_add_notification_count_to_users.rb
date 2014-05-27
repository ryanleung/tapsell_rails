class AddNotificationCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_count, :integer, default: 0
  end
end
