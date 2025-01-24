require 'rails_helper'

describe 'usuário deleta lembrete de venda de ingresso' do
  it 'e não está logado' do
    reminder = create(:reminder)

    delete reminder_path(id: reminder.id,  locale: :'pt-BR')


    expect(response).to redirect_to new_user_session_path
  end

  it 'e lembrete não existe' do
    user = create(:user)
    create(:reminder, id: 10, user: user)

    login_as user
    delete reminder_path(id: 999,  locale: :'pt-BR')

    expect(response).to redirect_to root_path(locale: :'pt-BR')
  end
end
