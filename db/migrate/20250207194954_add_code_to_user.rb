class AddCodeToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :code, :string, null: false
  end
end
