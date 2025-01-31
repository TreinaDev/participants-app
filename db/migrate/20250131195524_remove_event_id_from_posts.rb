class RemoveEventIdFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :event_id, :integer
  end
end
