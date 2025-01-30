class RemoveEventIdFromTickets < ActiveRecord::Migration[8.0]
  def change
    remove_column :tickets, :event_id, :integer
  end
end
