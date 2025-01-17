require 'rails_helper'

describe 'usuário atualiza seu perfil' do
  it 'e não está logado' do
    user = create(:user)
    profile = create(:profile, user: user, city: 'Teste', state: 'Estado')

    patch user_profile_path(user_id: user, id: profile), params: {
      profile: {
        city: 'Teste 05',
        state: 'Estado 05'
      }
    }

    profile.reload
    expect(response).to redirect_to new_user_session_path
    expect(profile.city).to eq 'Teste'
    expect(profile.state).to eq 'Estado'
  end
end
