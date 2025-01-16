class Profile < ApplicationRecord
  belongs_to :user
  has_many :phone_numbers
  has_many :social_links
end
