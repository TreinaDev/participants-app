class SocialLink < ApplicationRecord
  belongs_to :profile
  belongs_to :social_medium
end
