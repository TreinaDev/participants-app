require 'rails_helper'

describe 'usuário cria lembrete de venda de ingresso' do
  it 'e não está logado' do
    event = build(:event)

    post reminders_path(event_id: event.event_id,  locale: :'pt-BR')

    reminder = Reminder.all
    expect(response).to redirect_to new_user_session_path
    expect(reminder).to be_empty
  end

  it 'com evento inexistente' do
    user = create(:user)
    build(:event, event_id: 10)
    allow(Event).to receive(:request_event_by_id).and_return([])

    login_as user
    post reminders_path(event_id: 999,  locale: :'pt-BR')

    reminder = Reminder.where(event_id: 999)
    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(reminder).to be_empty
  end
end
