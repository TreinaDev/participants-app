require 'rails_helper'

describe 'usuário vê botão de compra de ingressos' do
  it 'com ingressos disponíveis' do
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 30,
      start_date: 1.day.ago.to_date,
      value: 10.00,
      end_date: 1.day.from_now.to_date,
      event_id: 1
    }, {
      id: 2,
      name: 'Mesmo Lote Teste',
      limit_tickets: 50,
      start_date: 2.day.ago.to_date,
      value: 20.00,
      end_date: 2.day.from_now.to_date,
      event_id: 1
    } ]
    events = []
    events << build(:event, name: 'Evento Teste 01')
    events << build(:event, name: 'Evento Teste 02')
    allow(Event).to receive(:all).and_return(events)
    event = build(:event, name: 'Evento Teste 01', batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit root_path
    click_on 'Eventos'
    click_on 'Evento Teste 01'

    expect(page).to have_link 'Ver Ingressos'
    expect(page).not_to have_link 'Ingressos Esgotados'
    expect(page).not_to have_content "Ingressos disponíveis #{I18n.l(1.day.from_now.to_date, format: :short)}"
  end

  it 'com vários ingressos fora da época de venda' do
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 30,
      start_date: 5.day.from_now.to_date,
      value: 10.00,
      end_date: 1.month.from_now.to_date,
      event_id: 1
    }, {
      id: 2,
      name: 'Mesmo Lote Teste',
      limit_tickets: 50,
      start_date: 3.day.from_now.to_date,
      value: 20.00,
      end_date: 3.month.from_now.to_date,
      event_id: 1
    }, {
      id: 3,
      name: 'Mesmo Mesmo Lote Teste',
      limit_tickets: 50,
      start_date: 2.day.from_now.to_date,
      value: 20.00,
      end_date: 2.month.from_now.to_date,
      event_id: 1
    } ]
    event = build(:event, name: 'Evento Teste 01', batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_path(id: event, locale: :'pt-BR')

    expect(page).not_to have_link 'Ver Ingressos'
    expect(page).not_to have_link 'Ingressos Esgotados'
    expect(page).not_to have_content "Ingressos disponíveis #{I18n.l(3.day.from_now.to_date, format: :short)}"
    expect(page).not_to have_content "Ingressos disponíveis #{I18n.l(5.day.from_now.to_date, format: :short)}"
    expect(page).to have_content "Ingressos disponíveis #{I18n.l(2.day.from_now.to_date, format: :short)}"
  end

  it 'com vários ingressos fora da época de venda' do
    event = build(:event, name: 'Evento Teste 01', batches: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_path(id: event, locale: :'pt-BR')

    expect(page).not_to have_link 'Ver Ingressos'
    expect(page).not_to have_link 'Ingressos Esgotados'
    expect(page).to have_content 'Sem ingressos disponíveis'
  end

  it 'e ingressos estão todos esgotados' do
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 10,
      start_date: 5.day.from_now.to_date,
      value: 10.00,
      end_date: 1.month.from_now.to_date,
      event_id: 1
    }, {
      id: 2,
      name: 'Mesmo Lote Teste',
      limit_tickets: 30,
      start_date: 3.day.from_now.to_date,
      value: 20.00,
      end_date: 3.month.from_now.to_date,
      event_id: 1
    }, {
      id: 3,
      name: 'Mesmo Mesmo Lote Teste',
      limit_tickets: 10,
      start_date: 2.day.from_now.to_date,
      value: 20.00,
      end_date: 2.month.from_now.to_date,
      event_id: 1
    } ]
    create_list(:ticket, 10) do |t|
      t.batch_id = batch[0][:batch_id]
    end
    create_list(:ticket, 30) do |t|
      t.batch_id = batch[1][:batch_id]
    end
    create_list(:ticket, 10) do |t|
      t.batch_id = batch[2][:batch_id]
    end
    event = build(:event, name: 'Evento Teste 01', batches: batch, limit_participants: 50)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_path(id: event, locale: :'pt-BR')

    expect(page).not_to have_link 'Ver Ingressos'
    expect(page).not_to have_content 'Sem ingressos disponíveis'
    expect(page).to have_link 'Ingressos Esgotados'
  end
end
