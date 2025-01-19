require 'rails_helper'

describe "Visitante remove favorito", type: :request do
  it 'e deve estar autenticado' do
    user = create(:user_with_favorites)

    delete(favorite_path(user.favorites.first.id))

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Usuário não autenticado'
  end
end