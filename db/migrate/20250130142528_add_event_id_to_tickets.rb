class AddEventIdToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :event_id, :string, null: false
  end
end
