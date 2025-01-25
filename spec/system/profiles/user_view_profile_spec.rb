require 'rails_helper'

describe 'usuário vê perfil' do
  it 'pela menu de navegação' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit root_path
    click_on 'teste@email.com'

    expect(current_path).to eq user_profile_path(user_id: user, id: Profile.first, locale: :'pt-BR')
  end

  it 'e não está logado' do
    user = create(:user)

    visit user_profile_path(user_id: user, id: Profile.first)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e não pode acessar de outro usuário' do
    user = create(:user)
    user_other = create(:user)

    login_as user
    visit user_profile_path(user_id: user_other, id: user_other.profile)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem autorização para acessar está página.'
  end
end
