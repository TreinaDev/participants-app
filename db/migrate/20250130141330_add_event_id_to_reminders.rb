class AddEventIdToReminders < ActiveRecord::Migration[8.0]
  def change
    add_column :reminders, :event_id, :string, null: false
  end
end
