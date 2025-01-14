class DropTableEvents < ActiveRecord::Migration[8.0]
  def change
    drop_table :events
  end
end
