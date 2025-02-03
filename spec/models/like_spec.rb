require 'rails_helper'

RSpec.describe Like, type: :model do
  describe '#unique_like' do
    it 'e consegue criar curtida' do
      user = create(:user)
      other_user = create(:user)
      event = build(:event, event_id: '1', name: 'DevWeek')
      create(:ticket, user: user, event_id: event.event_id)
      create(:ticket, user: other_user, event_id: event.event_id)
      post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
      like = build(:like, user: other_user, post: post)

      expect(like).to be_valid
    end

    it 'não consegue curtir postagem mais de uma vez' do
      user = create(:user)
      event = build(:event, event_id: '1', name: 'DevWeek')
      create(:ticket, user: user, event_id: event.event_id)
      post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
      like = build(:like, user: user, post: post)

      expect(like).not_to be_valid
      expect(like.errors.full_messages.last).to eq 'Você já curtiu esta postagem'
    end
  end

  describe '#check_user_is_participant' do
    it 'usuário não consegue curtir postagem de evento em que não participa' do
      user = create(:user)
      event = build(:event, event_id: '1', name: 'DevWeek')
      create(:ticket, user: user, event_id: event.event_id)
      post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
      other_user = create(:user)
      create(:ticket, user: other_user, event_id: event.event_id)
      like = build(:like, user: other_user, post: post)
      like.save

      expect(like).not_to be_valid
    end

    it 'usuário não consegue curtir postagem de evento em que não participa' do
      user = create(:user)
      event = build(:event, event_id: '1', name: 'DevWeek')
      create(:ticket, user: user, event_id: event.event_id)
      post = create(:post, user: user, event_id: event.event_id, title: 'Título Teste', content: '<b>Conteúdo Teste</b>')
      other_user = create(:user)

      like = build(:like, user: other_user, post: post)
      like.save

      expect(like).not_to be_valid
    end
  end

  describe 'validations' do
    context 'Usuário' do
      it { is_expected.to belong_to(:user) }
    end

    context 'Postagem' do
      it { is_expected.to belong_to(:post) }
    end
  end
end
