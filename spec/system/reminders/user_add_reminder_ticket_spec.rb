require 'rails_helper'

describe 'Usuário adiciona lembrete' do
  it 'e deve estar autenticado' do
    events = []
    events << build(:event, name: 'Evento Teste 01')
    events << build(:event, name: 'Evento Teste 02')
    allow(Event).to receive(:all).and_return(events)
    event = build(:event, name: 'Evento Teste 01')
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'Evento Teste 02'

    expect(page).not_to have_button 'Adicionar Lembrete'
  end

  it 'e não existem ingressos disponíveis dentro da data atual' do
    user = create(:user)
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 30,
      start_date: 1.day.from_now.to_date,
      value: 10.00,
      end_date: 1.day.from_now.to_date,
      event_id: 1
    }, {
      id: 2,
      name: 'Mesmo Lote Teste',
      limit_tickets: 50,
      start_date: 2.day.from_now.to_date,
      value: 20.00,
      end_date: 2.day.from_now.to_date,
      event_id: 1
    } ]
    event = build(:event, name: 'Evento Teste 01', batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).to have_button 'Adicionar Lembrete'
  end

  it 'com ingressos já esgotados' do
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
    } ]
    create_list(:ticket, 10) do |t|
      t.batch_id = batch[0][:batch_id]
    end
    create_list(:ticket, 30) do |t|
      t.batch_id = batch[1][:batch_id]
    end
    event = build(:event, name: 'Evento Teste 01', batches: batch, limit_participants: 50)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).not_to have_button 'Adicionar Lembrete'
  end

  it 'caso ingressos não estejam à venda' do
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 10,
      start_date: 5.day.ago.to_date,
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
    } ]
    event = build(:event, name: 'Evento Teste 01', batches: batch, limit_participants: 50)
    allow(Event).to receive(:request_event_by_id).and_return(event)

    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')

    expect(page).not_to have_button 'Adicionar Lembrete'
  end

  it 'com sucesso' do
    user = create(:user)
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 30,
      start_date: 1.day.from_now.to_date,
      value: 10.00,
      end_date: 1.day.from_now.to_date,
      event_id: 1
    }, {
      id: 2,
      name: 'Mesmo Lote Teste',
      limit_tickets: 50,
      start_date: 2.day.from_now.to_date,
      value: 20.00,
      end_date: 2.day.from_now.to_date,
      event_id: 1
    } ]
    event = build(:event, name: 'Evento Teste 01', batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event, event)

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')
    click_on 'Adicionar Lembrete'

    expect(page).not_to have_button 'Adicionar Lembrete'
    expect(page).to have_content 'Lembrete adicionado com sucesso'
    expect(page).to have_button 'Remover Lembrete'
  end

  it 'e agenda envio do email' do
    user = create(:user)
    batch = [ {
      id: 1,
      name: 'Lote Teste',
      limit_tickets: 30,
      start_date: 1.day.from_now.to_date,
      value: 10.00,
      end_date: 1.day.from_now.to_date,
      event_id: 1
    }, {
      id: 2,
      name: 'Mesmo Lote Teste',
      limit_tickets: 50,
      start_date: 2.day.from_now.to_date,
      value: 20.00,
      end_date: 2.day.from_now.to_date,
      event_id: 1
    } ]
    event = build(:event, name: 'Evento Teste 01', batches: batch)
    allow(Event).to receive(:request_event_by_id).and_return(event, event)
    mail = double('mail', deliver_later: true)
    mailer_double = double('RemindersMailer', ticket_reminder: mail)
    allow(RemindersMailer).to receive(:with).and_return(mailer_double)
    allow(mail).to receive(:ticket_reminder).and_return(mail)

    login_as user
    visit event_by_name_path(event_id: event, name: event.name.parameterize, locale: :'pt-BR')
    click_on 'Adicionar Lembrete'

    travel_to 1.day.from_now do
      expect(mailer_double).to have_received(:ticket_reminder).once
      expect(mail).to have_received(:deliver_later)
    end
  end
end
