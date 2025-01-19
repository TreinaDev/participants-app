require 'rails_helper'

describe 'Usuário acessa página de favoritos' do
  it 'e deve estar autenticado' do
    visit favorites_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e não possui favoritos' do
    user = create(:user)

    login_as user
    visit favorites_path

    expect(page).to have_content 'Você ainda não possui eventos favoritos'
  end

  it 'com sucesso' do
    user = create(:user)
    events = []
    event = build(:event,
      name: 'Aprendedo a cozinhar',
      banner: 'http://localhost:3000/events/1/banner.jpg',
      logo: 'http://localhost:3000/events/1/logo.jpg',
    )
    events << event
    create(:favorite, user_id: user.id, event_id: event.event_id)
    allow(Event).to receive(:request_favorites).and_return(events)

    login_as user
    visit favorites_path

    expect(page).to have_link 'Aprendedo a cozinhar'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'
    expect(page).to have_button 'Desfavoritar'
  end

  it 'e vê mais de um evento' do
    user = create(:user)
    events = []
    events << build(:event,
      name: 'Aprendedo a cozinhar',
      banner: 'http://localhost:3000/events/1/banner.jpg',
      logo: 'http://localhost:3000/events/1/logo.jpg',
    )
    events << build(:event,
      name: 'Aprendedo a voar',
      banner: 'http://localhost:3000/events/2/banner.jpg',
      logo: 'http://localhost:3000/events/2/logo.jpg',
    )

    events << build(:event,
      name: 'Aprendedo a nadar',
      banner: 'http://localhost:3000/events/3/banner.jpg',
      logo: 'http://localhost:3000/events/3/logo.jpg',
    )
    create(:favorite, user_id: user.id, event_id: events[0].event_id)
    create(:favorite, user_id: user.id, event_id: events[1].event_id)
    create(:favorite, user_id: user.id, event_id: events[2].event_id)
    allow(Event).to receive(:request_favorites).and_return(events)

    login_as user
    visit favorites_path

    expect(page).to have_link 'Aprendedo a cozinhar'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'

    expect(page).to have_link 'Aprendedo a voar'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/logo.jpg"]'

    expect(page).to have_link 'Aprendedo a nadar'
    expect(page).to have_css 'img[src="http://localhost:3000/events/3/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/3/logo.jpg"]'
  end

  it 'e desfavorita com sucesso' do
    user = create(:user)
    first_event = build(:event,
      name: 'Aprendedo a cozinhar',
      banner: 'http://localhost:3000/events/1/banner.jpg',
      logo: 'http://localhost:3000/events/1/logo.jpg',
    )
    second_event = build(:event,
      name: 'Aprendedo a voar',
      banner: 'http://localhost:3000/events/2/banner.jpg',
      logo: 'http://localhost:3000/events/2/logo.jpg',
    )

    third_event = build(:event,
      name: 'Aprendedo a nadar',
      banner: 'http://localhost:3000/events/3/banner.jpg',
      logo: 'http://localhost:3000/events/3/logo.jpg',
    )
    create(:favorite, user_id: user.id, event_id: first_event.event_id)
    create(:favorite, user_id: user.id, event_id: second_event.event_id)
    create(:favorite, user_id: user.id, event_id: third_event.event_id)
    allow(Event).to receive(:request_favorites).and_return([ first_event, second_event, third_event ], [ first_event, second_event ])

    login_as user
    visit favorites_path
    within("#event_id_#{third_event.event_id}") do
     click_on 'Desfavoritar'
    end

    expect(Favorite.count).to eq(2)
    expect(page).to have_content "Evento Desfavoritado"
    expect(page).to have_link 'Aprendedo a cozinhar'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/logo.jpg"]'

    expect(page).to have_link 'Aprendedo a voar'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/banner.jpg"]'
    expect(page).to have_css 'img[src="http://localhost:3000/events/2/logo.jpg"]'

    expect(page).not_to have_link 'Aprendedo a nadar'
    expect(page).not_to have_css 'img[src="http://localhost:3000/events/3/banner.jpg"]'
    expect(page).not_to have_css 'img[src="http://localhost:3000/events/3/logo.jpg"]'
  end
end
