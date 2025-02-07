class CreateTicketUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_usages do |t|
      t.references :ticket, null: false, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
