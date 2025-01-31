class RemoveBatchIdFromTickets < ActiveRecord::Migration[8.0]
  def change
    remove_column :tickets, :batch_id, :integer
  end
end
