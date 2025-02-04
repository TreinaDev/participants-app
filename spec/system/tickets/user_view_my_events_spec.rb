require 'rails_helper'

describe 'Usuário acessa página de meus eventos' do
  it 'a partir da página inicial' do
    user = create(:user)
    event1 = build(:event, name: 'DevWeek', logo: 'http://localhost:3000/events/1/logo.jpg',  banner: 'http://localhost:3000/events/1/banner.jpg')
    event2 = build(:event, name: 'Ruby', logo: 'http://localhost:3000/events/3/logo.jpg',  banner: 'http://localhost:3000/events/3/banner.jpg')
    create(:ticket, event_id: event1.event_id, user: user)
    create(:ticket, event_id: event2.event_id, user: user)

    allow(Event).to receive(:request_event_by_id).and_return(event1, event2)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

     within("#event_id_#{event1.event_id}") do
      expect(page).to have_content('DevWeek')
      expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
      expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'
      expect(page).to have_link('Acessar Conteúdo do Evento')
    end
    within("#event_id_#{event2.event_id}") do
      expect(page).to have_content('Ruby')
      expect(page).to have_css 'img[src="http://localhost:3000/events/3/banner.jpg"]'
      expect(page).to have_css 'img[src="http://localhost:3000/events/3/logo.jpg"]'
      expect(page).to have_link('Acessar Conteúdo do Evento')
    end
  end

  it 'e não está logado' do
    event = build(:event, name: 'DevWeek')
    events = [ event ]
    create(:ticket, event_id: event.event_id)
    allow(Event).to receive(:request_my_events).and_return(events)

    visit my_events_path(locale: :'pt-BR')

    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê eventos para os quais não comprou ingresso' do
    user = create(:user)
    other_user = create(:user)
    event1 = build(:event, name: 'DevWeek')
    event2 = build(:event, name: 'Ruby')
    create(:ticket, event_id: event1.event_id, user: user)
    create(:ticket, event_id: event2.event_id, user: other_user)
    allow(Event).to receive(:request_event_by_id).and_return(event1)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).to have_content('DevWeek')
    expect(page).not_to have_content('Ruby')
  end

  it 'e não vê botão de meus eventos quando não logado' do
    visit root_path

    expect(page).not_to have_link 'Meus Eventos'
  end

  it 'e não existem ingressos comprados' do
    user = create(:user)

    login_as user
    visit my_events_path(locale: :'pt-BR')

    expect(page).to have_content 'Você ainda não possui ingressos comprados'
  end

  it 'e não vê eventos repetidos' do
    user = create(:user)
    event1 = build(:event, name: 'DevWeek', event_id: '1')
    event2 = build(:event, name: 'Ruby', event_id: '2')
    events = { '1' => event1, '2' => event2 }
    create(:ticket, event_id: event1.event_id, user: user, batch_id: 1)
    create(:ticket, event_id: event1.event_id, user: user, batch_id: 2)
    event_ids = user.tickets.pluck(:event_id).uniq
    allow(Event).to receive(:request_event_by_id).and_return(*event_ids.map { |event_id| events[event_id] })

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    within("#event_id_#{event1.event_id}") do
      expect(page).to have_content('DevWeek')
      expect(page).to have_link('Acessar Conteúdo do Evento')
    end
    expect(page).not_to have_content('Ruby')
  end
end
