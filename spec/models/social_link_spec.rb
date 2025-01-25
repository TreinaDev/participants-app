require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  describe "#valid?" do
    context "URL" do
      it 'inválido quando não adiciona https' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Instagram')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'instagram.com')

        expect(social_link.valid?).to be_falsey
      end

      it 'inválido quando não adiciona .com' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Instagram')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'https://www.instagram')

        expect(social_link.valid?).to be_falsey
      end

      it 'inválido quando não adiciona www' do
        user = build(:user)
        social_medium = SocialMedium.create(name: 'Instagram')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'https://instagram.com')

        expect(social_link.valid?).to be_falsey
      end

      it 'válido com endereço completo' do
        user = create(:user)
        social_medium = SocialMedium.create(name: 'Instagram')
        social_link = SocialLink.new(profile: user.profile, social_medium_id: social_medium.id, url: 'https://www.instagram.com')

        expect(social_link.valid?).to be true
      end
    end
  end
end
