require 'rails_helper'

describe 'Visitante abre a app e ve lista de eventos', type: :system do
  it 'com sucesso' do
    events = []
    events << build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                     logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events << build(:event, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                                     logo: 'http://localhost:3000/events/2/logo.jpg', event_id: 2)
    allow(Event).to receive(:all).and_return(events)

    visit root_path
    click_on 'Eventos'

    expect(page).to have_content 'Eventos'
    expect(page).to have_link 'Dev Week'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'
    expect(page).to have_link 'Ruby Update'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/logo.jpg"]'
  end

  xit 'e não tem eventos disponiveis' do
    events = []
    allow(response).to receive(:all).and_return(events)

    visit root_path
    click_on 'Eventos'

    expect(page).to have_content 'Nenhum evento disponível'
  end
end
