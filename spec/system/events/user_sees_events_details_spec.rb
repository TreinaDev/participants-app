require 'rails_helper'

describe 'Usuário acessa página de detalhes de um evento' do
  it 'com sucesso' do
    user = create(:user)

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
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_content 'Aprendedo a cozinhar'
    expect(page).to have_content 'Local: Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil', normalize_ws: true
    expect(page).to have_content 'Aprenda a fritar um ovo'
    expect(page).to have_content 'Dono do evento: Samuel', normalize_ws: true
    expect(page).to have_content 'Limite de Participantes: 30', normalize_ws: true
    expect(page).to have_css 'img[src="http://localhost:3000/events/1/banner.jpg"]'
    expect(page).to have_content 'http://evento_fake.com'
  end

  it 'a partir da pagina inicial' do
    user = create(:user)
    event = build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                     logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events = [ event ]
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit root_path(locale: :'pt-BR')
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Dev Week'

    expect(current_path).to eq event_by_name_path(event_id: 1, name: event.name.parameterize, locale: :'pt-BR')
  end

  it 'e consegue ver os detalhes da agenda do evento' do
    user = create(:user)
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
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

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
    batch = [ {
      batch_id: 1,
      name: 'Lote Teste',
      limit_tickets: 30,
      start_date: 5.day.ago.to_date,
      value: 10.00,
      end_date: 10.day.from_now.to_date,
      event_id: 1
      }
    ]
    user = create(:user)
    event = build(:event,  event_agendas: [], batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event)


    login_as(user)
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_link 'Ver Ingressos'
  end

  it 'e visualiza que não há programação para o evento' do
    user = create(:user)
    event = build(:event,  event_agendas: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_content 'Ainda não existe programação cadastrada para esse evento'
  end

  it 'e mostra mensagem de erro para evento não encontrado' do
    user = build(:user)
    response = double('response', status: 404, body: '')
    allow(Faraday).to receive(:get).and_return(response)
    allow(response).to receive(:success?).and_return(false)

    login_as(user)
    visit event_by_name_path(event_id: 1, name: "xablau", locale: :'pt-BR')

    expect(current_path).to eq root_path
    expect(page).to have_content "Evento não encontrado"
  end
end
