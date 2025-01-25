class AddPhoneNumberToProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :phone_number, :string
  end
end
