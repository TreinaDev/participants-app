require 'rails_helper'

describe 'Visitante acessa página de detalhes de um evento' do
  it 'com sucesso' do
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
    event = build(:event, name: 'Dev Week', banner: 'http://localhost:3000/events/1/banner.jpg',
                                     logo: 'http://localhost:3000/events/1/logo.jpg', event_id: 1)
    events = [ event ]
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Dev Week'

    expect(current_path).to eq "/pt-BR/events/1/dev-week"
  end

  it 'e consegue ver os detalhes da agenda do evento' do
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "ABCD1423",
            description: 'novo teste pra  passar',
            schedule_type: 'activity',
            responsible_name: 'Sílvio Santos',
            responsible_email: 'silvio@sbt.com'
          }
        ]
      },
      {
        date: 	"2025-02-15",
        schedule_items: [
          {
            name:	"Apresentação",
            start_time:	"2025-02-15T09:00:00.000-03:00",
            end_time:	"2025-02-15T10:00:00.000-03:00",
            code: "ABCD1424",
            description: 'apresentação de slides',
            schedule_type: 'activity',
            responsible_name: 'Hebe Soares',
            responsible_email: 'soareshebe@sbt.com'
          }
        ]
      },
      {
        date: 	"2025-02-16",
        schedule_items: []
      }

    ]
    event = build(:event,
      schedules: schedules
    )

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Speaker).to receive(:request_speakers_by_email).and_return([])

    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_content "14/02/2025"
    expect(page).to have_content "Palestra"
    expect(page).to have_content "Início: 09:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "Tipo: atividade"
    expect(page).to have_content "Responsável: Sílvio Santos"
    expect(page).to have_content "Email: silvio@sbt.com"

    expect(page).to have_content "15/02/2025"
    expect(page).to have_content "Apresentação"
    expect(page).to have_content "Início: 09:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "Tipo: atividade"
    expect(page).to have_content "Responsável: Hebe Soares"
    expect(page).to have_content "Email: soareshebe@sbt.com"

    expect(page).to have_content "16/02/2025"
    expect(page).to have_content 'Ainda não existe programação cadastrada para esse dia'
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
    event = build(:event, batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event)


    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_link 'Ver Ingressos'
  end

  it 'e visualiza que não há programação para o evento' do
    event = build(:event)
    allow(Event).to receive(:request_event_by_id).and_return(event)


    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_content 'Ainda não existe programação cadastrada para esse evento'
  end

  it 'e mostra mensagem de erro para evento não encontrado' do
    response = double('response', status: 404, body: '')
    allow(Faraday).to receive(:get).and_return(response)
    allow(response).to receive(:success?).and_return(false)

    visit event_by_name_path(event_id: 1, name: "Xablau", locale: :'pt-BR')

    expect(page).to have_content "Evento não encontrado"
    expect(current_path).to eq root_path
  end

  it 'e vê informações sobre os palestrantes' do
    event = build(:event,
      event_id: "1",
      name: 'Aprendedo a cozinhar',
      local_event: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
      description: 'Aprenda a fritar um ovo',
      event_owner: 'Samuel',
      limit_participants: 30,
      banner: 'http://localhost:3000/events/1/banner.jpg',
      url_event: 'http://evento_fake.com',
      schedules: [
        {
        date: 1.day.from_now,
        schedule_items: []
        }
        ]
    )
    event.schedules[0].schedule_items << build(:schedule_item) << build(:schedule_item)

    speakers = []
    speakers << build(:speaker, first_name: "Sílvio",
    last_name: "Santos",
    profile_image_url: "http://localhost:3000/speaker/1/speaker.jpg",
    profile_url: "http://localhost:3000/speaker/1/profile.jpg", role: "Professor")
    speakers << build(:speaker, first_name: "Goku",
    last_name: "Kakaroto",
    profile_image_url: "http://localhost:3000/speaker/2/speaker.jpg",
    profile_url: "http://localhost:3000/speaker/2/profile.jpg", role: "Lutador")

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Speaker).to receive(:request_speakers_by_email).and_return(speakers)

    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    within(:xpath, "//a[@href='http://localhost:3000/speaker/1/profile.jpg']") do
      expect(page).to have_content 'Sílvio Santos'
      expect(page).to have_content 'Profissão: Professor'
      expect(page).to have_css 'img[src="http://localhost:3000/speaker/1/speaker.jpg"]'
    end

    within(:xpath, "//a[@href='http://localhost:3000/speaker/2/profile.jpg']") do
      expect(page).to have_content 'Goku Kakaroto'
      expect(page).to have_content 'Profissão: Lutador'
      expect(page).to have_css 'img[src="http://localhost:3000/speaker/2/speaker.jpg"]'
    end
  end
end
