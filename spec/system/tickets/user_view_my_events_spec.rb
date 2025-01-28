require 'rails_helper'

describe 'Usuário acessa página de meus eventos' do
  it 'a partir da página inicial' do
    user = create(:user)
    event1 = build(:event, name: 'DevWeek')
    event2 = build(:event, name: 'Ruby')
    events = [ event1, event2 ]
    create(:ticket, event_id: event1.event_id, user: user)
    create(:ticket, event_id: event2.event_id, user: user)

    allow(Event).to receive(:request_my_events).and_return(events)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).to have_link('DevWeek')
    expect(page).to have_link('Ruby')
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
    event1 = build(:event, name: 'DevWeek')
    event2 = build(:event, name: 'Ruby')
    events = [ event1, event2 ]
    create(:ticket, event_id: event1.event_id, user: user)
    allow(Event).to receive(:request_my_events).and_return(events)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).to have_content('DevWeek')
    expect(page).not_to have_content('Ruby')
  end

  it 'e não vê botão de meus eventos' do
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
    event1 = build(:event, name: 'DevWeek')
    event2 = build(:event, name: 'Ruby')
    events = [ event1, event2 ]
    create(:ticket, event_id: event1.event_id, user: user)
    create(:ticket, event_id: event1.event_id, user: user)

    allow(Event).to receive(:request_my_events).and_return(events)

    login_as user
    visit root_path
    click_on 'Meus Eventos'

    expect(page).to have_link('DevWeek').once
  end
end
