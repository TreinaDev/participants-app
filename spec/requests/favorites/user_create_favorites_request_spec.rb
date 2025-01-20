require 'rails_helper'

describe "Visitante cria favorito", type: :request do
  it 'e deve estar autenticado' do
    event = build(:event)

    post(favorites_path, params: { event_id: event.event_id })

    expect(response).to redirect_to new_user_session_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Usuário não autenticado'
  end
end
