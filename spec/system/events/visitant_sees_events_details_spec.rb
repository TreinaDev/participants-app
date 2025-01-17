require 'rails_helper'

describe 'Visitante acessa página de detalhes de um evento' do
  it 'com sucesso' do
    event = build(:event,
      event_id: "1",
      name: 'Aprendedo a cozinhar',
      local_event: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
      description: 'Aprenda a fritar um ovo',
      event_owner: 'Samuel',
    )
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_path(event.event_id)

    expect(page).to have_content 'Aprendedo a cozinhar'
    expect(page).to have_content 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
    expect(page).to have_content 'Aprenda a fritar um ovo'
    expect(page).to have_content 'Criado por: Samuel'
  end

  it 'e consegue ver os detalhes da agenda do evento' do
    event_agendas = [ {
      event_agenda_id: 1,
      date: '15/08/2025',
      title: 'Aprendendo a cozinhar massas',
      description: 'lorem ipsum',
      instructor: 'Elefante',
      email: 'elefante@email.com',
      start_time: '07:00',
      duration: 120,
      type: 'Palestra'
    }, {
      event_agenda_id: 1,
      date: '15/08/2025',
      title: 'Aprendendo a fritar salgados',
      description: 'lorem ipsum',
      instructor: 'Jacaré',
      email: 'jacare@email.com',
      start_time: '11:00',
      duration: 120,
      type: 'Work-shop'
    }
    ]
    event = build(:event,
      event_agendas: event_agendas
    )

    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_path(event.event_id)

    expect(page).to have_content "Aprendendo a cozinhar massas"
    expect(page).to have_content "lorem ipsum"
    expect(page).to have_content "Elefante"
    expect(page).to have_content "elefante@email.com"
    expect(page).to have_content "07:00"
    expect(page).to have_content "120"
    expect(page).to have_content "Palestra"

    expect(page).to have_content "Aprendendo a fritar salgados"
    expect(page).to have_content "lorem ipsum"
    expect(page).to have_content "Jacaré"
    expect(page).to have_content "jacare@email.com"
    expect(page).to have_content "11:00"
    expect(page).to have_content "120"
    expect(page).to have_content "Work-shop"
  end

  it 'e visualiza opção de ver ingressos' do
    event = build(:event,  event_agendas: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)


    visit event_path(event.event_id)

    expect(page).to have_link 'Ver ingressos'
  end

  it 'e visualiza que não há programação para o evento' do
    event = build(:event,  event_agendas: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)


    visit event_path(event.event_id)

    expect(page).to have_content 'Ainda não existe programação cadastrada para esse evento'
  end

  it 'e mostra mensagem de erro para evento não encontrado' do
    response = double('response', status: 404, body: '')
    allow(Faraday).to receive(:get).and_return(response)
    allow(response).to receive(:success?).and_return(false)

    visit event_path(1)

    expect(page).to have_content "Evento não encontrado"
    expect(current_path).to eq root_path
  end
end
