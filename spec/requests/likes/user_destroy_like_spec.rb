require 'rails_helper'

describe 'Usuário deleta curtida', type: :request do
  it 'e não está autenticado' do
    event = build(:event)
    post = create(:post, event_id: event.event_id)
    ticket = create(:ticket, event_id: event.event_id)
    like = create(:like, user: ticket.user, post: post)

    delete event_post_like_path(event_id: event.event_id, post_id: post.id, id: like.id)

    expect(response).to redirect_to new_user_session_path
  end

  it 'e não é participante do evento' do
    user = create(:user)
    event = build(:event)
    post = create(:post, event_id: event.event_id)
    ticket = create(:ticket, event_id: event.event_id)
    like = create(:like, user: ticket.user, post: post)

    login_as user
    delete event_post_like_path(event_id: event.event_id, post_id: post.id, id: like.id, locale: :'pt-BR')

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Você não participa deste evento'
  end

  it 'e não é o dono do curtida' do
    user = create(:user)
    event = build(:event)
    ticket = create(:ticket, event_id: event.event_id, user: user)
    post = create(:post, user: user, event_id: event.event_id)
    other_user = create(:user)
    create(:ticket, user: other_user, event_id: event.event_id)
    like = post.likes.first

    login_as other_user
    delete event_post_like_path(event_id: event.event_id, post_id: post.id, id: like.id, locale: :'pt-BR')

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Você não pode remover a curtida desta postagem'
  end
end
