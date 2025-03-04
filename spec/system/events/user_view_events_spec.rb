require 'rails_helper'

describe 'Usuário abre a app e vê lista de eventos', type: :system do
  it 'com sucesso' do
    user = create(:user)
    events = []
    travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
    events << build(:event, event_id: 1, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                            logo: 'http://localhost:3000/events/1/logo.jpg', start_date: 2.days.from_now,
                            end_date: 5.days.from_now)
    events << build(:event, event_id: 2, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                            logo: 'http://localhost:3000/events/2/logo.jpg', start_date: 5.days.from_now,
                            end_date: 7.days.from_now)

    allow(Event).to receive(:all).and_return(events)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end

    expect(page).to have_content 'Eventos'
    expect(page).to have_link 'Dev Week'
    expect(page).to have_content 'Data de início: 03 de janeiro de 2024'
    expect(page).to have_link 'Dev Week'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'
    expect(page).to have_link 'Ruby Update'
    expect(page).to have_content 'Data de início: 06 de janeiro de 2024'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/logo.jpg"]'
  end

  it 'E não visualiza eventos que já aconteceram.' do
    events = []
    events << build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                     logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1, start_date: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0))
    events << build(:event, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                                     logo: 'http://localhost:3000/events/2/logo.jpg', event_id: 2, start_date: (Time.now - 2.day).change(hour: 8, min: 0, sec: 0))
    allow(Event).to receive(:all).and_return(events)

    visit root_path
    within('nav') do
      click_on 'Eventos'
    end

    expect(page).to have_content 'Eventos'
    expect(page).to have_link 'Dev Week'
    expect(page).not_to have_link 'Ruby Update'
  end

  it 'e não tem eventos disponiveis' do
    user = create(:user)
    events = []
    allow(Event).to receive(:all).and_return(events)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end

    expect(page).to have_content 'Nenhum evento disponível'
  end

  it 'e filtra por query strings' do
    travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
    user = create(:user)
    events = []
    events << build(:event, event_id: 1, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                            logo: 'http://localhost:3000/events/1/logo.jpg', start_date: 2.days.from_now,
                            end_date: 5.days.from_now)
    events << build(:event, event_id: 2, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                            logo: 'http://localhost:3000/events/2/logo.jpg', start_date: 5.days.from_now,
                            end_date: 7.days.from_now)

    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:search_events).with('Ruby').and_return([ events[1] ])

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    fill_in "Filtre aqui seu evento",	with: "Ruby"
    click_on "Pesquisar"

    expect(page).to have_content 'Eventos'
    expect(page).not_to have_link 'Dev Week'
    expect(page).not_to have_content 'Data de início: 03 de janeiro de 2024'
    expect(page).not_to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).not_to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'
    expect(page).to have_link 'Ruby Update'
    expect(page).to have_content 'Data de início: 06 de janeiro de 2024'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/logo.jpg"]'
  end

  it 'e não tem eventos disponiveis no filtro por query strings' do
    user = create(:user)
    events = []
    first_events = []
    first_events << build(:event, event_id: 1, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                            logo: 'http://localhost:3000/events/1/logo.jpg', start_date: 2.days.from_now,
                            end_date: 5.days.from_now)
    first_events << build(:event, event_id: 2, name: 'Ruby Update', banner: 'http://localhost:3000/events/2/banner.jpg',
                            logo: 'http://localhost:3000/events/2/logo.jpg', start_date: 5.days.from_now,
                            end_date: 7.days.from_now)

    allow(Event).to receive(:all).and_return(first_events)
    allow(Event).to receive(:search_events).and_return(events)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    fill_in "Filtre aqui seu evento",	with: "ruby"
    click_on "Pesquisar"

    expect(page).to have_content 'Nenhum evento disponível'
  end
end
