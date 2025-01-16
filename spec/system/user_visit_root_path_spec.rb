require 'rails_helper'

describe 'Visitante abre a app e ve lista de eventos', type: :system do
  it 'com sucesso' do
    events = [
      { id: 1, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
        logo: 'http://localhost:3000/events/1/logo.jpg' },
      { id: 2, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
        logo: 'http://localhost:3000/events/2/logo.jpg' }
    ]
    response = double('response', status: 200, body: events.to_json)
    allow(response).to receive(:success?). and_return(true)
    allow(Faraday).to receive(:get).with('http://localhost:3000/events').and_return(response)

    visit root_path

    expect(page).to have_content 'Eventos'
    expect(page).to have_link 'Dev Week'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'
    expect(page).to have_link 'Ruby Update'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/logo.jpg"]'
  end

  it 'api não disponivel' do
    response = double('response', status: 404)
    allow(response).to receive(:status).and_return(Faraday::Error)

    visit root_path

    expect(page).to have_content 'Nenhum evento disponível'
  end
end
