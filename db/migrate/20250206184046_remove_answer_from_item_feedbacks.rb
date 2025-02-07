class RemoveAnswerFromItemFeedbacks < ActiveRecord::Migration[8.0]
  def change
    remove_column :item_feedbacks, :answer, :string
  end
end
