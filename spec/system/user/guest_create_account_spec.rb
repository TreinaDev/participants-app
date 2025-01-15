require 'rails_helper'

describe 'visitante cria conta' do
  it 'pela página inicial' do
    visit root_path

    expect(page).to have_link 'Login'
  end

  it 'com sucesso' do
    visit root_path
    click_on 'Login'
    fill_in 'Nome',	with: 'Cristiano'
    fill_in 'Sobrenome',	with: 'Santana'
    fill_in 'E-mail',	with: 'cristiano@email.com'
    fill_in 'CPF',	with: '35687402809'
    fill_in 'Senha',	with: '123456'
    fill_in 'Confirmar Senha',	with: '123456'
    click_on 'Salvar Conta'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'cristiano@email.com'
  end

  it 'e vê mensagens de erros' do
    visit new_user_registration_path
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'E-mail', with: 'teste@email.com'
    fill_in 'CPF', with: ''
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmar Senha', with: '123456'
    click_on 'Salvar Conta'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
  end
end
