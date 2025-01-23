class AddSocialMediumToSocialLink < ActiveRecord::Migration[8.0]
  def change
    add_reference :social_links, :social_medium, null: false, foreign_key: true
  end
end
