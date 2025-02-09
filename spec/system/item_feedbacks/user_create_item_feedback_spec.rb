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

    within("#schedule_item_code_1") do
      expect(page).to have_link 'Adicionar Feedback'
      expect(page).not_to have_content 'Workshop'
    end
    within("#schedule_item_code_2") do
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
    within("#schedule_item_code_1") do
      click_on 'Adicionar Feedback'
    end
    fill_in 'Título', with: 'Avaliação do Iten'
    fill_in 'Comentário', with: 'A atividade foi genial, mais a comida foi péssima'
    find('label[for="hs-ratings-readonly-4"]').click
    check 'Público'
    click_on 'Adicionar Feedback'

    expect(page).to have_content 'Feedback adicionado com sucesso'
    expect(page).to have_content 'Atividade: Palestra'
    expect(page).to have_content 'Avaliação do Iten'
    expect(page).to have_content 'Feedback Público'
    expect(page).to have_content 'Nota: 4'
  end

  it 'e vê mensagens de campo obrigatório' do
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
    ticket = create(:ticket, event_id: event.event_id)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    visit new_my_event_schedule_item_item_feedback_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id)
    fill_in 'Título', with: ''
    fill_in 'Comentário', with: ''
    find('label[for="hs-ratings-readonly-4"]').click
    check 'Público'
    click_on 'Adicionar Feedback'

    expect(page).to have_content 'Falha ao salvar o Feedback'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Comentário não pode ficar em branco'
  end

  it 'mas não participa do evento' do
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
    user = create(:user)
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 1.days.ago, name: 'DevWeek', schedules: schedules)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit new_my_event_schedule_item_item_feedback_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não participa deste evento'
  end

  it 'e não aparece botão se evento ainda não finalizou' do
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
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 1.day.from_now, name: 'DevWeek', schedules: schedules)
    batch =  build(:batch, name: 'Entrada - VIP', limit_tickets: 50, start_date: 10.days.ago.to_date,
                           value: 40.00, end_date: 1.month.from_now.to_date, event_id: event.event_id)
    ticket = create(:ticket, event_id: event.event_id, batch_id: batch.batch_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Batch).to receive(:request_batch_by_id).and_return(batch)

    login_as ticket.user
    visit root_path
    click_on 'Meus Eventos'
    click_on 'Acessar Conteúdo do Evento'

    expect(page).not_to have_link 'Adicionar Feedback'
  end

  it 'mas o evento não terminou' do
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
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 1.day.from_now, name: 'DevWeek', schedules: schedules)
    ticket = create(:ticket, event_id: event.event_id)
    schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    visit new_my_event_schedule_item_item_feedback_path(my_event_id: event.event_id, schedule_item_id: schedule_item.schedule_item_id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Este evento ainda está em andamento'
  end

  it 'mas o item da agenda é do outro evento' do
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
    event = build(:event, event_id: '1', start_date: 5.day.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
    other_event = build(:event, event_id: '2', start_date: 5.day.ago, end_date: 2.days.ago, name: 'Other DevWeek')
    ticket = create(:ticket, event_id: other_event.event_id)
    event_schedule_item = event.schedules[0].schedule_items[0]
    allow(Event).to receive(:request_event_by_id).and_return(other_event)

    login_as ticket.user
    visit new_my_event_schedule_item_item_feedback_path(my_event_id: other_event.event_id, schedule_item_id: event_schedule_item.schedule_item_id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Essa atividade não existe'
  end
end
