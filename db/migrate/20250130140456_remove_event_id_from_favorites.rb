class RemoveEventIdFromFavorites < ActiveRecord::Migration[8.0]
  def change
    remove_column :favorites, :event_id, :integer
  end
end
