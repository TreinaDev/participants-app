class CreateSocialMedia < ActiveRecord::Migration[8.0]
  def change
    create_table :social_media do |t|
      t.string :name

      t.timestamps
    end
  end
end
