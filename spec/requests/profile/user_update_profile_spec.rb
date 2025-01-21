require 'rails_helper'

describe 'usuário atualiza seu perfil' do
  it 'e não está logado' do
    user = create(:user)
    profile = create(:profile, user: user, city: 'Teste', state: 'Estado')

    patch user_profile_path(user_id: user, id: profile,  locale: :'pt-BR'), params: {
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

  it 'logado e tenta atualizar de outro' do
    user = create(:user)
    create(:profile, user: user, city: 'Londrina', state: 'Paraná')
    other_user = create(:user)
    other_profile = create(:profile, user: other_user, city: 'Recife', state: 'Pernambuco')

    login_as user
    patch user_profile_path(user_id: other_user, id: other_user.profile,  locale: :'pt-BR'), params: {
      profile: {
        city: 'São Paulo',
        state: 'São Paulo'
      }
    }

    other_profile.reload
    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(other_profile.city).to eq 'Recife'
    expect(other_profile.state).to eq 'Pernambuco'
  end
end
