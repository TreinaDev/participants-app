require 'rails_helper'

describe 'Usuário ve feedback de um evento' do
  it 'e deve estar autenticado' do
    event = build(:event, name: 'DevWeek', event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    feedback = create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: ticket.user, public: true)

    visit my_event_feedback_path(my_event_id: feedback.event_id, id: feedback.id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    batches = [ {
        batch_id: '1',
        name: 'Entrada - Meia',
        limit_tickets: 20,
        start_date: 5.days.ago.to_date,
        value: 20.00,
        end_date: 2.month.from_now.to_date,
        event_id: '1'
      }
    ]
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1')
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: ticket.user, public: true)
    visit my_event_path(event.event_id, locale: :'pt-BR')
    click_on 'Título Padrão'

    expect(page).to have_content 'Título Padrão'
    expect(page).to have_content 'Comentário Padrão'
    expect(page).to have_content 'Nota: 3'
  end

  it 'mas não participa do evento' do
    user = create(:user)
    event = build(:event, name: 'DevWeek', event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    feedback = create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: ticket.user, public: true)

    visit my_event_feedback_path(my_event_id: feedback.event_id, id: feedback.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end
end
