class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.string :event_id, null: false
      t.references :user, null: false, foreign_key: true
      t.string :coment,   null: false
      t.string :title,    null: false
      t.integer :mark,    null: false
      t.boolean :public,  null: false, default: false

      t.timestamps
    end
  end
end
