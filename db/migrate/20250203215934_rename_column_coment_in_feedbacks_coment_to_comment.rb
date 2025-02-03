class RenameColumnComentInFeedbacksComentToComment < ActiveRecord::Migration[8.0]
  def change
    rename_column :feedbacks, :coment, :comment
  end
end
