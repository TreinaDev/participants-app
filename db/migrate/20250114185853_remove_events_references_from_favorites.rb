class RemoveEventsReferencesFromFavorites < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :favorites, :events
    remove_index :favorites, :event_id
  end
end
