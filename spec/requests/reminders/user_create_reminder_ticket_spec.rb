require 'rails_helper'

describe 'usuário cria lembrete de venda de ingresso' do
  it 'e não está logado' do
    event = build(:event)

    post reminders_path(event_id: event.event_id,  locale: :'pt-BR')

    reminder = Reminder.all
    expect(response).to redirect_to new_user_session_path
    expect(reminder).to be_empty
  end
end
