class AddUsageStatusToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :usage_status, :integer, default: 0
  end
end
