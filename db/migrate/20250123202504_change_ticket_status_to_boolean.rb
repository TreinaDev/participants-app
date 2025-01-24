class ChangeTicketStatusToBoolean < ActiveRecord::Migration[8.0]
  def change
    change_column :tickets, :status, :boolean, default: false
  end
end
