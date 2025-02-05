class CreateItemFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :item_feedbacks do |t|
      t.string :title,            null: false
      t.string :comment,          null: false
      t.string :answer
      t.integer :mark,            null: false, default: false
      t.boolean :public,          null: false
      t.string :event_id,         null: false
      t.references :user,         null: false, foreign_key: true
      t.string :schedule_item_id, null: false

      t.timestamps
    end
  end
end
