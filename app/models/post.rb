class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :comments

  validates :title, :content, presence: true
end
