class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title, null: false
      t.string :content, null: false
      t.integer :event_id, null: false

      t.timestamps
    end
  end
end
