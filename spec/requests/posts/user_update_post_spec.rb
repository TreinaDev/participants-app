require 'rails_helper'

describe 'Participante edita uma postagem', type: :request do
  it 'e deve estar autenticado' do
    event = build(:event)
    post = create(:post, title: 'Título', content: 'Conteúdo')

    patch event_post_path(event_id: event.event_id, id: post.id), params: {
      post: {
        title: 'Título Teste',
        content: 'Conteudo Teste'
      }
    }

    expect(response).to redirect_to new_user_session_path
  end

  it 'e deve ser participante do evento' do
    user = create(:user)
    event = build(:event)
    post = create(:post, event_id: event.event_id, title: 'Título', content: 'Conteúdo')

    login_as user
    patch event_post_path(event_id: event.event_id, id: post.id), params: {
      post: {
        title: 'Título Teste',
        content: 'Conteudo Teste'
      }
    }

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Você não participa deste evento'
  end

  it 'com parâmetros incorretos' do
    user = create(:user)
    event = build(:event)
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, user: user, event_id: event.event_id, title: 'Título', content: 'Conteúdo')

    login_as user
    patch event_post_path(event_id: event.event_id, id: post.id), params: {
      post: {
        title: '',
        content: ''
      }
    }

    expect(flash[:alert]).to eq 'Falha ao salvar a postagem'
  end

  it 'de outro usuário' do
    user = create(:user)
    event = build(:event)
    create(:ticket, user: user, event_id: event.event_id)
    post = create(:post, user: user, event_id: event.event_id, title: 'Título', content: 'Conteúdo')
    ticket = create(:ticket, event_id: event.event_id)
    other_user = ticket.user

    login_as other_user
    patch event_post_path(event_id: event.event_id, id: post.id), params: {
      post: {
        title: 'COMPRE BITCOIN',
        content: 'MENSAGEM PERIGOSA'
      }
    }

    expect(flash[:alert]).to eq 'Você não tem acesso a essa página'
  end
end
