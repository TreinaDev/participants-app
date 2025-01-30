class Reminder < ApplicationRecord
  belongs_to :user

  validates :event_id, :user, :start_date,  presence: true
  validates :event_id, numericality: { only_integer: true }
  validates_comparison_of :start_date, greater_than: -> { Date.today }
end
