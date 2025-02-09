require 'rails_helper'

describe 'Usuário ve feedbacks de um evento' do
  it 'e deve estar autenticado' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit new_my_event_feedback_path(my_event_id: event.event_id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)
    create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                      user: ticket.user, public: true)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit root_path
      click_on 'Meus Eventos'
      click_on 'Acessar a meus feedbacks'

      expect(page).to have_content 'Evento: DevWeek'
      expect(page).to have_content 'Título Padrão'
      expect(page).to have_content 'Feedback Público'
      expect(page).to have_content 'Nota: 3'
    end
  end

  it 'e não vê os feedbacks de outros usuarios' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    second_ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(3)
    create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                      user: ticket.user, public: true)
    create(:feedback, title: 'Título Padrão 2', comment: 'Comentário Padrão 2', mark: 4, event_id: event.event_id,
                      user: second_ticket.user, public: true)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit root_path
      click_on 'Meus Eventos'
      click_on 'Acessar a meus feedbacks'

      expect(page).to have_content 'Evento: DevWeek'
      expect(page).to have_content 'Título Padrão'
      expect(page).to have_content 'Feedback Público'
      expect(page).to have_content 'Nota: 3'
      expect(page).not_to have_content 'Título Padrão 2'
      expect(page).not_to have_content 'Nota: 4'
    end
  end

  it 'e não vê os feedbacks de outros evento' do
    user = create(:user)
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    second_event = build(:event, event_id: '2', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'Itamar')
    ticket = create(:ticket, event_id: event.event_id, user: user)
    second_ticket = create(:ticket, event_id: second_event.event_id, user: user)
    allow(Event).to receive(:request_event_by_id).and_return(event, second_event)
    create(:feedback, title: 'Título Padrão 1', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                      user: ticket.user, public: true)
    create(:feedback, title: 'Título Padrão 2', comment: 'Comentário Padrão 2', mark: 4, event_id: second_event.event_id,
                      user: second_ticket.user, public: true)

    travel_to 6.days.from_now do
      login_as ticket.user
      visit root_path
      click_on 'Meus Eventos'
      within "#event_id_2" do
        click_on 'Acessar a meus feedbacks'
      end

      expect(page).not_to have_content 'Evento: DevWeek'
      expect(page).not_to have_content 'Título Padrão 1'
      expect(page).not_to have_content 'Nota: 3'
      expect(page).to have_content 'Evento: Itamar'
      expect(page).to have_content 'Título Padrão 2'
      expect(page).to have_content 'Feedback Público'
      expect(page).to have_content 'Nota: 4'
    end
  end

  it 'mas não participa do evento' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    user = create(:user)
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(2)
    create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
                      user: ticket.user, public: true)

    travel_to 6.days.from_now do
      login_as user
      visit my_event_feedbacks_path(my_event_id: event.event_id)

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

    expect(page).not_to have_link 'Acessar a meus feedbacks'
  end

  it 'mas o evento não terminou' do
    event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
    ticket = create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_event_by_id).and_return(event).exactly(2)

    login_as ticket.user
    visit my_event_feedbacks_path(my_event_id: event.event_id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Este evento ainda está em andamento'
  end
end
