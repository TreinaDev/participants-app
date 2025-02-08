require 'rails_helper'

describe 'Usuário cria feedback de um evento' do
  it 'e deve estar autenticado' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit new_my_event_feedback_path(my_event_id: event.event_id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'pela página de meus eventos' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 4.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit root_path
      click_on 'Meus Eventos'

      expect(page).to have_link 'Adicionar Feedback'
    end
  end

  it 'com sucesso' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit new_my_event_feedback_path(my_event_id: event.event_id)
      fill_in 'Título', with: 'Avaliação da DevWeek'
      fill_in 'Comentário', with: 'O evento foi genial, mais a comida foi péssima'
      find('label[for="hs-ratings-readonly-4"]').click
      check 'Público'
      click_on 'Adicionar Feedback'

      expect(page).to have_content 'Feedback adicionado com sucesso'
      expect(page).to have_content 'Evento: DevWeek'
      expect(page).to have_content 'Título: Avaliação da DevWeek'
      expect(page).to have_content 'Feedback Público'
      expect(page).to have_content 'Comentário: O evento foi genial, mais a comida foi péssima'
      expect(page).to have_content 'Nota: 4'
    end
  end

  it 'e vê mensagens de campo obrigatório' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit new_my_event_feedback_path(my_event_id: event.event_id)
      fill_in 'Título', with: ''
      fill_in 'Comentário', with: ''
      within('.rating-stars') do
        find('label[for="hs-ratings-readonly-4"]').click
      end
      check 'Público'
      click_on 'Adicionar Feedback'

      expect(page).to have_content 'Falha ao salvar o Feedback'
      expect(page).to have_content 'Título não pode ficar em branco'
      expect(page).to have_content 'Comentário não pode ficar em branco'
    end
  end

  it 'mas não participa do evento' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    user = create(:user)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(2)

    travel_to 6.days.from_now do
      login_as user
      visit new_my_event_feedback_path(my_event_id: event.event_id)

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não participa deste evento'
    end
  end

  it 'e não aparece botão se evento ainda não finalizou' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as ticket.user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).not_to have_link 'Adicionar Feedback'
  end

  it 'mas o evento não terminou' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(2)

    login_as ticket.user
    visit new_my_event_feedback_path(my_event_id: event.event_id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Este evento ainda está em andamento'
  end
end
