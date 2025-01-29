class AddEventIdToTicket < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :event_id, :integer, null: false
  end
end
