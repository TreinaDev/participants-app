require 'rails_helper'

describe 'Usuário acessa página de detalhes de um evento' do
  it 'com sucesso' do
    user = build(:user)

    event = build(:event,
      event_id: "1",
      name: 'Aprendedo a cozinhar',
      local_event: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
      description: 'Aprenda a fritar um ovo',
      event_owner: 'Samuel',
      limit_participants: 30,
      banner: 'http://localhost:3000/events/1/banner.jpg',
      url_event: 'http://evento_fake.com'
    )
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit event_path(event.event_id)

    expect(page).to have_content 'Aprendedo a cozinhar'
    expect(page).to have_content 'Local: Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
    expect(page).to have_content 'Aprenda a fritar um ovo'
    expect(page).to have_content 'Criado por: Samuel'
    expect(page).to have_content 'Limite de Participantes: 30'
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_content 'http://evento_fake.com'
  end

  it 'a partir da pagina inicial' do
    user = build(:user)
    event = build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                     logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events = [ event ]
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit root_path
    click_on 'Eventos'
    click_on 'Dev Week'

    expect(current_path).to eq event_path(1)
  end

  it 'e consegue ver os detalhes da agenda do evento' do
    user = build(:user)
    event_agendas = [ {
      event_agenda_id: 1,
      date: '15/08/2025',
      title: 'Aprendendo a cozinhar massas',
      description: 'lorem ipsum',
      instructor: 'Elefante',
      email: 'elefante@email.com',
      start_time: '07:00',
      duration: 100,
      agenda_type: 'Palestra'
    }, {
      event_agenda_id: 1,
      date: '15/08/2025',
      title: 'Aprendendo a fritar salgados',
      description: 'lorem ipsum',
      instructor: 'Jacaré',
      email: 'jacare@email.com',
      start_time: '11:00',
      duration: 120,
      agenda_type: 'Work-shop'
    }
    ]
    event = build(:event,
      event_agendas: event_agendas
    )

    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit event_path(event.event_id)

    expect(page).to have_content "Aprendendo a cozinhar massas"
    expect(page).to have_content "lorem ipsum"
    expect(page).to have_content "Instrutor: Elefante"
    expect(page).to have_content "Contato: elefante@email.com"
    expect(page).to have_content "Início: 07:00"
    expect(page).to have_content "Duração: 120min"
    expect(page).to have_content "Tipo do Evento: Palestra"

    expect(page).to have_content "Aprendendo a fritar salgados"
    expect(page).to have_content "lorem ipsum"
    expect(page).to have_content "Instrutor: Jacaré"
    expect(page).to have_content "Contato: jacare@email.com"
    expect(page).to have_content "Início: 11:00"
    expect(page).to have_content "Duração: 100min"
    expect(page).to have_content "Tipo do Evento: Work-shop"
  end

  it 'e visualiza opção de ver ingressos' do
    user = build(:user)
    event = build(:event,  event_agendas: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)


    login_as(user)
    visit event_path(event.event_id)

    expect(page).to have_link 'Ver ingressos'
  end

  it 'e visualiza que não há programação para o evento' do
    user = build(:user)
    event = build(:event,  event_agendas: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit event_path(event.event_id)

    expect(page).to have_content 'Ainda não existe programação cadastrada para esse evento'
  end

  it 'e mostra mensagem de erro para evento não encontrado' do
    user = build(:user)
    response = double('response', status: 404, body: '')
    allow(Faraday).to receive(:get).and_return(response)
    allow(response).to receive(:success?).and_return(false)

    login_as(user)
    visit event_path(1)

    expect(page).to have_content "Evento não encontrado"
    expect(current_path).to eq root_path
  end
end
