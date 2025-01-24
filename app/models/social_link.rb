class SocialLink < ApplicationRecord
  VALID_URL_REGEX = /\Ahttps:\/\/www\.[a-zA-Z0-9]+(\.[a-zA-Z]+)+(\/[\w\-_.#?=&+]*)*\z/
  belongs_to :profile
  belongs_to :social_medium
  validate :url_valid?

  private

  def url_valid?
    errors.add(:url, :invalid_url) unless url.match?(VALID_URL_REGEX)
  end
end
