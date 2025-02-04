class ChangeColumnEventIdInAnnouncements < ActiveRecord::Migration[8.0]
  def change
    change_column :announcements, :event_id, :string
  end
end
