class CreateFeedbackAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :feedback_answers do |t|
      t.string :name
      t.string :comment
      t.string :email
      t.references :item_feedback, null: false, foreign_key: true

      t.timestamps
    end
  end
end
