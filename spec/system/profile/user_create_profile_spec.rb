require 'rails_helper'

describe 'usuário cria perfil' do
  it 'pela barra de navegação' do
    user = create(:user, email: 'teste@email.com')
    create(:profile, user: user)

    login_as user
    visit root_path

    expect(page).to have_link 'teste@email.com'
  end

  it 'automaticamente após se cadastrar' do
    visit root_path
    click_on 'Inscrever-se'
    fill_in 'Nome',	with: 'Cristiano'
    fill_in 'Sobrenome',	with: 'Santana'
    fill_in 'E-mail',	with: 'cristiano@email.com'
    fill_in 'CPF',	with: '22099395004'
    fill_in 'Senha',	with: '123456'
    fill_in 'Confirmar Senha',	with: '123456'
    click_on 'Salvar Conta'
    click_on 'cristiano@email.com'

    profile = Profile.last
    expect(profile).not_to eq nil
    expect(page).to have_content 'Cidade'
    expect(page).to have_content 'Estado'
    expect(page).to have_content 'Telefones'
    expect(page).to have_content 'Links'
    expect(page).to have_content 'Perfil'
  end
end
