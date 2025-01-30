class AddEventIdToFavorites < ActiveRecord::Migration[8.0]
  def change
    add_column :favorites, :event_id, :string, null: false
  end
end
