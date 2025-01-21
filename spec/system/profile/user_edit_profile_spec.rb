require 'rails_helper'

describe 'usuário edita perfil' do
  it 'pela página do perfil' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit root_path
    click_on 'teste@email.com'

    expect(page).to have_link 'Editar Perfil'
  end

  it 'com sucesso' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit edit_user_profile_path(user_id: user, id: user.profile)
    fill_in 'Cidade', with: 'TesteCidade'
    fill_in 'Estado', with: 'TesteEstado'
    fill_in 'Telefone', with: '11912125454'
    click_on 'Salvar Informações'

    expect(current_path).to eq user_profile_path(user_id: user, id: user.profile, locale: :'pt-BR')
    expect(page).to have_content 'Perfil atualizado'
    expect(page).to have_content 'TesteCidade'
    expect(page).to have_content 'TesteEstado'
    expect(page).to have_content '11912125454'
  end

  it 'e não está logado' do
    user = create(:user)

    visit edit_user_profile_path(user_id: user, id: user.profile)

    expect(current_path).to eq new_user_session_path
  end

  it 'e não pode editar de outro usuário' do
    user = create(:user)
    user_other = create(:user)

    login_as user
    visit edit_user_profile_path(user_id: user_other, id: user_other.profile)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem autorização para acessar está página.'
  end
end
