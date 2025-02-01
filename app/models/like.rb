class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validate :unique_like
  before_create :check_user_is_participant

  def unique_like
    if Like.exists?(user: user, post: post)
      errors.add(:base, :unique_like)
    end
  end

  def check_user_is_participant
    unless user.participates_in_event? post.event_id
      errors.add(:base, :check_user_is_participant)
    end
  end
end
