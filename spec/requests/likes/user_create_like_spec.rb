require 'rails_helper'

describe 'Usuário cria curtida', type: :request do
  it 'e não está autenticado' do
    event = build(:event)
    post = create(:post, event_id: event.event_id)

    post event_post_likes_path(event_id: event.event_id, post_id: post.id)

    expect(response).to redirect_to new_user_session_path
  end

  it 'e não é participante do evento' do
    user = create(:user)
    event = build(:event)
    post = create(:post, event_id: event.event_id)

    login_as user
    post event_post_likes_path(event_id: event.event_id, post_id: post.id, locale: :"pt-BR")

    expect(response).to redirect_to root_path(locale: :"pt-BR")
    expect(flash[:alert]).to eq 'Você não participa deste evento'
  end
end
