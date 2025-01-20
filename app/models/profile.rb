class Profile < ApplicationRecord
  belongs_to :user
  has_many :social_links
end
