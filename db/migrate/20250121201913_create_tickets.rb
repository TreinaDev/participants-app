class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.integer :status
      t.datetime :date_of_purchase
      t.integer :payment_method
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.integer :batch_id

      t.timestamps
    end
  end
end
