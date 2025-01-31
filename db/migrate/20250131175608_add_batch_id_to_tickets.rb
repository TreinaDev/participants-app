class AddBatchIdToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :batch_id, :string
  end
end
