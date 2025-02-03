require 'rails_helper'

describe 'Usuário cria feedback de um evento que terminou' do
  it 'pela página de meus eventos' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
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
    allow(Event).to receive(:request_event_by_id).and_return(event)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit new_my_event_feedback_path(my_event_id: event.event_id)
      save_page
      fill_in 'Título', with: 'Avaliação da DevWeek'
      fill_in 'Comentario', with: 'O evento foi genial, mais a comida foi péssima'
      select '4', from: 'Nota'
      check 'Público'
      click_on 'Adicionar Feedback'

      expect(page).to have_content 'Feedback adicionado com sucesso'
      expect(page).to have_content 'Evento: DevWeek'
      expect(page).to have_content 'Título: Avaliação da DevWeek'
      expect(page).to have_content 'Feedback Público'
      expect(page).to have_content 'Comentario: O evento foi genial, mais a comida foi péssima'
      expect(page).to have_content 'Nota: 4'
    end
  end
end
