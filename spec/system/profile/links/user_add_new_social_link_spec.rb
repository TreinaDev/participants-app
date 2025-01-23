require 'rails_helper'

describe 'usuário adiciona link social ao perfil' do
  it 'pela página do perfil' do
    user = create(:user, email: 'teste@email.com')

    login_as user
    visit root_path
    click_on 'teste@email.com'

    expect(page).to have_link 'Adicionar Link Social'
  end

  it 'e vê formulário para adicionar link social' do
    user = create(:user)
    SocialMedium.create(name: 'Instagram')
    SocialMedium.create(name: 'Linkedin')
    SocialMedium.create(name: 'GitHub')
    SocialMedium.create(name: 'Reddit')
    SocialMedium.create(name: 'Facebook')

    login_as user
    visit user_profile_path(user_id: user, id: user.profile)
    click_on 'Adicionar Link Social'

    expect(page).to have_css 'h3', text: 'Adicione um link'
    expect(page).to have_select 'Redes Sociais', options: [ 'Instagram', 'Linkedin', 'GitHub', 'Reddit', 'Facebook' ]
    expect(page).to have_field 'URL'
    expect(page).to have_button 'Salvar Link'
  end

  it 'e não está logado' do
    user = create(:user)

    visit new_user_profile_social_link_path(user_id: user, profile_id: user.profile)

    expect(current_path).to eq new_user_session_path
  end

  it 'e não pode adicionar no perfil de outro usuário' do
    user = create(:user)
    other_user = create(:user)

    login_as user
    visit new_user_profile_social_link_path(user_id: other_user, profile_id: other_user.profile)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode acessar essa página'
  end

  it 'com sucesso' do
    user = create(:user)
    SocialMedium.create(name: 'Facebook')

    login_as user
    visit new_user_profile_social_link_path(user_id: user, profile_id: user.profile)
    select 'Facebook', from: 'Redes Sociais'
    fill_in 'URL', with: 'https://www.facebook.com'
    click_on 'Salvar Link'

    expect(current_path).to eq user_profile_path(user_id: user, id: user.profile, locale: :'pt-BR')
    expect(page).to have_content 'Perfil atualizado'
    expect(page).to have_link 'Facebook'
    expect(page).to have_selector('a[href="https://www.facebook.com"]')
  end

  it 'e link deve ser valido' do
    user = create(:user)
    SocialMedium.create(name: 'Facebook')

    login_as user
    visit new_user_profile_social_link_path(user_id: user, profile_id: user.profile)
    select 'Facebook', from: 'Redes Sociais'
    fill_in 'URL', with: 'facebook.com'
    click_on 'Salvar Link'

    expect(page).to have_content 'URL não é válido'
  end

  it 'e não cria dois links da mesma rede social' do
    user = create(:user)
    SocialMedium.create(name: 'Facebook')
    SocialLink.create(profile: user.profile, social_medium_id: 1, url: 'https://www.facebook.com')

    login_as user
    visit new_user_profile_social_link_path(user_id: user, profile_id: user.profile)
    select 'Facebook', from: 'Redes Sociais'
    fill_in 'URL', with: 'https://www.facebook.com/1'
    click_on 'Salvar Link'

    expect(current_path).to eq user_profile_path(user_id: user, id: user.profile, locale: :'pt-BR')
    expect(page).to have_content 'Perfil atualizado'
    expect(page).to have_link 'Facebook'
    expect(page).to have_selector('a[href="https://www.facebook.com/1"]')
    expect(page).not_to have_selector('a[href="https://www.facebook.com"]')
  end
end
