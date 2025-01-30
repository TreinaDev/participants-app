class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.integer :event_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
