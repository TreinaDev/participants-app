require 'rails_helper'

describe "Visitante remove favorito", type: :request do
  it 'e deve estar autenticado' do
    user = create(:user_with_favorites)

    delete(favorite_path(id: user.favorites.first.id, locale: :'pt-BR'))

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

  it 'e deve ser o usuário do evento favoritado' do
    user = create(:user_with_favorites)
    user_two = create(:user)

    login_as user_two
    delete(favorite_path(id: user.favorites.first.id, locale: :'pt-BR'))

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Você não possui permissão para realizar essa ação'
  end
end
