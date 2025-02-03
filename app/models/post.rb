class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :likes
  has_many :comments

  validates :title, :content, presence: true

  after_create :automatic_post_like

  def liked_by?(user)
    likes.exists?(user: user)
  end

  private

  def automatic_post_like
    self.likes.create!(user: self.user)
  end
end
