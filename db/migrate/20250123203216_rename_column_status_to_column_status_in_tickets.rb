class RenameColumnStatusToColumnStatusInTickets < ActiveRecord::Migration[8.0]
  def change
    rename_column :tickets, :status, :status_confirmed
  end
end
