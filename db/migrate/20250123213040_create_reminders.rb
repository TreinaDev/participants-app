class CreateReminders < ActiveRecord::Migration[8.0]
  def change
    create_table :reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.integer :event_id, null: false

      t.timestamps
    end
  end
end
