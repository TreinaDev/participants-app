require 'rails_helper'

describe 'Usuário feedback de um  item de um evento' do
  it 'e deve estar autenticado' do
    schedules = [
      {
        date: 	5.day.ago,
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	5.day.ago.beginning_of_day + 9.hours,
            end_time:	5.day.ago.beginning_of_day + 10.hours,
            code: '1'
          }
        ]
      }
    ]
    event = build(:event, name: 'DevWeek', event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago, schedules: schedules)
    schedule_item = event.schedules[0].schedule_items[0]
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    item_feedback = create(:item_feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: ticket.user, public: true, schedule_item_id: schedule_item.schedule_item_id)

    visit my_event_schedule_item_item_feedback_path(my_event_id: item_feedback.event_id, schedule_item_id: item_feedback.schedule_item.schedule_item_id, id: item_feedback.id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    schedules = [
      {
        date: 	5.day.ago,
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	5.day.ago.beginning_of_day + 9.hours,
            end_time:	5.day.ago.beginning_of_day + 10.hours,
            code: '1'
          }
        ]
      }
    ]
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
    event = build(:event, name: 'DevWeek', batches: batches, event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago, schedules: schedules)
    schedule_item = event.schedules[0].schedule_items[0]
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1')
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with("1", '1').and_return(batches[0])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    create(:item_feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: ticket.user, public: true, schedule_item_id: schedule_item.schedule_item_id)
    visit my_event_path(event.event_id, locale: :'pt-BR')
    click_on 'Título Padrão'

    expect(page).to have_content 'Título Padrão'
    expect(page).to have_content 'Comentário Padrão'
    expect(page).to have_content 'Nota: 3'
  end

  it 'mas não participa do evento' do
    user = create(:user)
    schedules = [
      {
        date: 	5.day.ago,
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	5.day.ago.beginning_of_day + 9.hours,
            end_time:	5.day.ago.beginning_of_day + 10.hours,
            code: '1'
          }
        ]
      }
    ]
    event = build(:event, name: 'DevWeek', event_id: '1', start_date: 5.days.ago, end_date: 1.day.ago, schedules: schedules)
    schedule_item = event.schedules[0].schedule_items[0]
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    item_feedback = create(:item_feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                                      user: ticket.user, public: true, schedule_item_id: schedule_item.schedule_item_id)

    visit my_event_schedule_item_item_feedback_path(my_event_id: item_feedback.event_id, schedule_item_id: item_feedback.schedule_item.schedule_item_id, id: item_feedback.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end
end
