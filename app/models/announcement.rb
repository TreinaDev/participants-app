class Announcement < ApplicationRecord
  validates :event_id, :title, :content, presence: true
end
