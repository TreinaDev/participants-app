require 'rails_helper'

describe 'Usuario ve detalhes de um evento', type: :system do
  it 'a partir da pagina inicial' do
    event = build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                     logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events = [ event ]
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit root_path
    click_on 'Dev Week'

    expect(current_path).to eq event_path(1)
  end
end
