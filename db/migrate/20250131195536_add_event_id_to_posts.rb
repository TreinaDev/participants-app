class AddEventIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :event_id, :string
  end
end
