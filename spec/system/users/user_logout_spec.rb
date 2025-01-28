require 'rails_helper'

describe 'usuário faz logout' do
  it 'pela barra de navegação' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit root_path
    click_on "Olá, #{user.name}"


    expect(page).to have_button 'Sair'
  end

  it "com sucesso e não vê o botão de sair" do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit root_path
    click_on "Olá, #{user.name}"
    click_on 'Sair'

    expect(page).not_to have_button 'Sair'
    expect(page).to have_content 'Inscrever-se'
    expect(page).not_to have_content 'teste@email.com'
  end
end
