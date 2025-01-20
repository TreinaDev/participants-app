require 'rails_helper'

describe "Visitante remove favorito", type: :request do
  it 'e deve estar autenticado' do
    user = create(:user_with_favorites)

    delete(favorite_path(user.favorites.first.id))

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Usuário não autenticado'
  end

  it 'e deve ser o usuário do evento favoritado' do
    user = create(:user_with_favorites)
    user_two = create(:user)

    login_as user_two
    delete(favorite_path(user.favorites.first.id))

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não possui permissão para realizar essa ação'
  end
end
