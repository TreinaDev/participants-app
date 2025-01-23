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
    SocialMedium.create(name: 'Instagram', icon: Rails.root.join('spec', 'support', 'instagram.svg'))
    SocialMedium.create(name: 'Linkedin', icon: Rails.root.join('spec', 'support', 'linkedin.svg'))
    SocialMedium.create(name: 'GitHub', icon: Rails.root.join('spec', 'support', 'github.svg'))
    SocialMedium.create(name: 'Reddit', icon: Rails.root.join('spec', 'support', 'reddit.svg'))
    SocialMedium.create(name: 'Facebook', icon: Rails.root.join('spec', 'support', 'facebook.svg'))

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
    SocialMedium.create(name: 'Facebook', icon: Rails.root.join('spec', 'support', 'facebook.svg'))

    login_as user
    visit new_user_profile_social_link_path(user_id: user, profile_id: user.profile)
    select 'Facebook', from: 'Redes Sociais'
    fill_in 'URL', with: 'www.facebook.com'
    click_on 'Salvar Link'

    expect(current_path).to eq user_profile_path(user_id: user, id: user.profile, locale: :'pt-BR')
    expect(page).to have_content 'Perfil atualizado'
    expect(page).to have_css 'img[src*="facebook.svg"]'
    expect(page).to have_selector(:css, 'a[href="www.facebook.com"]')
  end
end
