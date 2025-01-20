require 'rails_helper'

describe 'usuário adiciona link social ao seu perfil' do
  it 'e não está logado' do
    user = create(:user)
    profile = create(:profile, user: user)

    post user_profile_social_links_path(user_id: user, profile_id: profile), params: {
      social_link: {
        name: 'Teste 05',
        url: 'URL 05'
      }
    }

    profile.reload
    expect(response).to redirect_to new_user_session_path
    expect(profile.social_links.empty?).to be true
  end

  it 'logado e tenta atualizar outro' do
    user = create(:user)
    profile = create(:profile, user: user)
    other_user = create(:user)
    other_profile = create(:profile, user: other_user)

    login_as user
    post user_profile_social_links_path(user_id: other_user, profile_id: other_profile), params: {
      social_link: {
        name: 'Instagram',
        url: 'https://instagram.com/@other_user'
      }
    }

    profile.reload
    expect(response).to redirect_to root_path
    expect(profile.social_links.empty?).to be true
  end
end
