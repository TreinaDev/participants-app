class Feedback < ApplicationRecord
  belongs_to :user

  validates :title, :comment, :mark, presence: true
  validates :comment, length: { maximum: 150 }
  validates :mark, inclusion: { in: [ 1, 2, 3, 4, 5 ] }
end
