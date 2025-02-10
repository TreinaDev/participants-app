class ItemFeedback < ApplicationRecord
  belongs_to :user
  validates :title, :comment, :mark, presence: true
  validates :comment, length: { maximum: 150 }
  validates :mark, inclusion: { in: [ 1, 2, 3, 4, 5 ] }
  has_many :feedback_answer

  def schedule_item
    event = Event.request_event_by_id(self.event_id)
    event.schedules.flat_map(&:schedule_items).find { |item_schedule| item_schedule.schedule_item_id == self.schedule_item_id }
  end

  def user_identification
    self.public ? user.full_name : "Anônimo"
  end
end
