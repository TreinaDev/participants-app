require 'rails_helper'

describe 'Participante cria uma postagem', type: :request do
  it 'e deve estar autenticado' do
    event = build(:event)
    post event_posts_path(event_id: event.event_id), params: {
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

    login_as user
    post event_posts_path(event_id: event.event_id), params: {
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

    login_as user
    post event_posts_path(event_id: event.event_id), params: {
      post: {
        title: '',
        content: ''
      }
    }

    expect(flash[:alert]).to eq 'Falha ao salvar a postagem'
  end
end
