require 'rails_helper'

describe 'Usuário cria comentário', type: :request do
  it 'e não está autenticado' do
    event = build(:event, event_id: 1)
    ticket = create(:ticket)
    post = create(:post, event_id: event.event_id, user: ticket.user)

    post event_post_comments_path(event_id: event.event_id, post_id: post.id), params: { comment: { content: 'Comentário Teste' } }

    expect(response).to redirect_to new_user_session_path
  end

  it 'e não participa do evento' do
    user = create(:user)
    event = build(:event, event_id: 1)
    ticket = create(:ticket)
    post = create(:post, event_id: event.event_id, user: ticket.user)

    login_as user
    post event_post_comments_path(event_id: event.event_id, post_id: post.id, locale: :'pt-BR'), params: { comment: { content: 'Comentário Teste' } }

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Você não participa deste evento'
  end
end
