require 'rails_helper'

describe 'Usuario cria um feedback para um item de um evento', type: :request do
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
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)

    post my_event_schedule_item_item_feedbacks_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id), params: { item_feedback:
      {
        title: 'Avaliação',
        comment: 'Comentário',
        mark: 1
      }
    }

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

  it 'mas o evento ainda está em andamento' do
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
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek', schedules: schedules)
    ticket = create(:ticket, event_id: event.event_id)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    post my_event_schedule_item_item_feedbacks_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id), params: { item_feedback:
      {
        title: 'Avaliação',
        comment: 'Comentário',
        mark: 1
      }
    }

    expect(response).to redirect_to root_path(locale: :'pt-BR')
    expect(flash[:alert]).to eq 'Este evento ainda está em andamento'
  end

  it 'com parâmetros incorretos' do
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
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
    ticket = create(:ticket, event_id: event.event_id)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)


    login_as ticket.user
    post my_event_schedule_item_item_feedbacks_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id), params: { item_feedback:
      {
        title: '',
        comment: '',
        mark: 10
      }
    }

    expect(flash[:alert]).to eq 'Falha ao salvar o Feedback'
  end
end
