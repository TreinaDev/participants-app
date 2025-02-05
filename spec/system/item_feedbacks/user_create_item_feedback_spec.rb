require 'rails_helper'

describe 'Usuário cria feedback de um item de um evento' do
  it 'pela página de meus eventos' do
    schedules = [
      {
        date: 	5.day.ago,
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	5.day.ago.beginning_of_day + 9.hours,
            end_time:	5.day.ago.beginning_of_day + 10.hours,
            code: '1'
          },
          {
            name:	"Workshop",
            start_time:	4.day.ago.beginning_of_day + 9.hours,
            end_time:	4.day.ago.beginning_of_day + 10.hours,
            code: '2'
          }
        ]
      }
    ]
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 1.days.ago, name: 'DevWeek', schedules: schedules)
    batch =  build(:batch, name: 'Entrada - VIP', limit_tickets: 50, start_date: 10.days.ago.to_date,
                           value: 40.00, end_date: 1.month.from_now.to_date, event_id: event.event_id)
    ticket = create(:ticket, event_id: event.event_id, batch_id: batch.batch_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Batch).to receive(:request_batch_by_id).and_return(batch)

    login_as ticket.user
    visit root_path
    click_on 'Meus Eventos'
    click_on 'Acessar Conteúdo do Evento'

    within("#1") do
      expect(page).to have_link 'Adicionar Feedback'
      expect(page).not_to have_content 'Workshop'
    end
    within("#2") do
      expect(page).to have_link 'Adicionar Feedback'
      expect(page).not_to have_content 'Palestra'
    end
  end

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
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 1.days.ago, name: 'DevWeek', schedules: schedules)
    create(:ticket, event_id: event.event_id)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit new_my_event_schedule_item_item_feedback_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id)

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
          },
          {
            name:	"Workshop",
            start_time:	5.day.ago.beginning_of_day + 12.hours,
            end_time:	5.day.ago.beginning_of_day + 13.hours,
            code: '2'
          }
        ]
      },
      {
        date: 	4.day.ago,
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	4.day.ago.beginning_of_day + 15.hours,
            end_time:	4.day.ago.beginning_of_day + 16.hours,
            code: '3'
          }
        ]
      }
    ]
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 1.days.ago, name: 'DevWeek', schedules: schedules)
    batch =  build(:batch, name: 'Entrada - VIP', limit_tickets: 50, start_date: 10.days.ago.to_date,
                           value: 40.00, end_date: 1.month.from_now.to_date, event_id: event.event_id)
    ticket = create(:ticket, event_id: event.event_id, batch_id: batch.batch_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Batch).to receive(:request_batch_by_id).and_return(batch)


    login_as ticket.user
    visit my_event_path(id: event.event_id)
    within("#1") do
      click_on 'Adicionar Feedback'
    end

    fill_in 'Título', with: 'Avaliação do Iten'
    fill_in 'Comentário', with: 'A atividade foi genial, mais a comida foi péssima'
    select '4', from: 'Nota'
    check 'Público'
    click_on 'Adicionar Feedback'

    expect(page).to have_content 'Feedback adicionado com sucesso'
    expect(page).to have_content 'Iten do evento: Palestra'
    expect(page).to have_content 'Título: Avaliação do Iten'
    expect(page).to have_content 'Feedback Público'
    expect(page).to have_content 'Comentário: A atividade foi genial, mais a comida foi péssima'
    expect(page).to have_content 'Nota: 4'
  end
end
