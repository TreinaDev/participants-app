class DropPhoneNumbers < ActiveRecord::Migration[8.0]
  def change
    drop_table :phone_numbers
  end
end
