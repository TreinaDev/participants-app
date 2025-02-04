class DropTableAnnouncements < ActiveRecord::Migration[8.0]
  def change
    drop_table :announcements
  end
end
