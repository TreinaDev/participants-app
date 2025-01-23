require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  describe "#valid?" do
    context "URL deve ser válido" do
      it 'https' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Facebook')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'instagram.com')

        social_link.valid?

        expect(social_link.errors.include?(:url)).to be true
      end

      it '.com' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Facebook')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'https://www.instagram')

        social_link.valid?

        expect(social_link.errors.include?(:url)).to be true
      end

      it 'www' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Facebook')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'https://instagram.com')

        social_link.valid?

        expect(social_link.errors.include?(:url)).to be true
      end

      it 'com endereço completo' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Facebook')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'https://www.instagram.com')

        social_link.valid?

        expect(social_link.errors.include?(:url)).to be false
      end
    end
  end
end
