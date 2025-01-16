class CreateSocialLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :social_links do |t|
      t.string :url
      t.string :name
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
