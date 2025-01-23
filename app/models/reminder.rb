class Reminder < ApplicationRecord
  belongs_to :user

  validates :event_id, :user,  presence: true
  validates :event_id, numericality: { only_integer: true }
end
