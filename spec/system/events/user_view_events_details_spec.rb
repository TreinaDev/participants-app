require 'rails_helper'

describe 'Usuario ve detalhes de um evento', type: :system do
  it 'a partir da pagina inicial' do
    event_one = { id: 1, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                  logo: 'http://localhost:3000/events/1/logo.jpg' }
    event_two = { id: 2, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                  logo: 'http://localhost:3000/events/2/logo.jpg' }
    events = [ event_one, event_two ]

    response_list = double('response_list', status: 200, body: events.to_json)
    allow(response_list).to receive(:success?). and_return(true)
    allow(Faraday).to receive(:get).with('http://localhost:3000/events').and_return(response_list)

    response_details = double('response_details', status: 200, body: events.to_json)
    allow(Faraday).to receive(:get).with('http://localhost:3000/events/1').and_return(response_details)

    visit root_path
    click_on 'Dev Week'

    expect(current_path).to eq event_path(1)
  end
end
