class FeedbackAnswer < ApplicationRecord
  belongs_to :item_feedback

  validates :name, :email, :comment, presence: true
  validates :comment, length: { maximum: 150 }
end
