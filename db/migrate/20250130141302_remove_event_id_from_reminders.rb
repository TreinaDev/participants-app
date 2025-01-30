class RemoveEventIdFromReminders < ActiveRecord::Migration[8.0]
  def change
    remove_column :reminders, :event_id, :integer
  end
end
