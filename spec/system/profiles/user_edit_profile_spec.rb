require 'rails_helper'
require 'webmock/rspec'

describe 'usuário edita perfil' do
  it 'pela página do perfil' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit root_path
    click_on "Olá, #{user.name}"
    click_on "Meu Perfil"

    expect(page).to have_link 'Editar Perfil'
  end

  it 'com sucesso', type: :system, js: true do
    user = create(:user, email: 'teste@email.com')

    stub_request(:get, "https://brasilapi.com.br/api/ibge/uf/v1")
      .to_return(status: 200, body: '[{"nome": "Bahia", "sigla": "BA"}]', headers: {})

    stub_request(:get, "https://brasilapi.com.br/api/ibge/municipios/v1/BA")
      .to_return(status: 200, body: '[{"nome": "Salvador"}, {"nome": "Feira de Santana"}]', headers: {})

    login_as user
    visit edit_user_profile_path(user_id: user, id: user.profile)
    select 'Bahia', from: 'Estado'

    select 'SALVADOR', from: 'Cidade'

    fill_in 'Telefone', with: '11912125454'
    click_on 'Salvar Informações'

    expect(current_path).to eq user_profile_path(user_id: user, id: user.profile, locale: :'pt-BR')
    expect(page).to have_content 'Perfil atualizado'
    expect(page).to have_content 'Bahia'
    expect(page).to have_content 'SALVADOR'
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

  it 'e volta pa página de perfil' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit edit_user_profile_path(user_id: user, id: user.profile)
    click_on 'Voltar'

    expect(current_path).to eq user_profile_path(user_id: user, id: user.profile, locale: :'pt-BR')
  end
end
