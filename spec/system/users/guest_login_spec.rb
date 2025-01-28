require 'rails_helper'

describe 'visitante faz login' do
  it 'pela barra de navegação' do
    visit root_path

    expect(page).to have_link 'Entrar'
  end

  it 'com sucesso' do
    user = create(:user, email: 'teste@email.com', password: '123456')

    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail',	with: 'teste@email.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content "Olá, #{user.name}"
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_button 'Entrar'
  end
end
