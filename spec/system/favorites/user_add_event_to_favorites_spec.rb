require 'rails_helper'

describe 'Usuário adiciona um evento a seus favoritos' do
  it 'com sucesso' do
    user = create(:user)
    events = []
    first_event = build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events << first_event
    events << build(:event, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                                     logo: 'http://localhost:3000/events/2/logo.jpg', event_id: 2)
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(first_event)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Dev Week'
    click_on 'Adicionar a favoritos'

    expect(page).to have_content 'Evento adicionado a favoritos com sucesso'
    expect(page).not_to have_button 'Adicionar a favoritos'
  end

  it 'é deve estar autenticado' do
    events = []
    first_event = build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events << first_event
    events << build(:event, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                                     logo: 'http://localhost:3000/events/2/logo.jpg', event_id: 2)
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(first_event)

    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Dev Week'
    click_on 'Adicionar a favoritos'

    expect(current_path).to eq new_user_session_path
  end
end
