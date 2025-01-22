require 'rails_helper'

describe 'Usuário acessa página de tipos de ingresso de um evento' do
  it 'e deve estar autenticado' do
    event = build(:event, name: 'Dev Week')
    batches = [ build(:batch, name: 'Entrada - VIP', limit_tickets: 50, start_date: 2.days.ago.to_date,
                value: 40.00, end_date: 1.month.from_now.to_date, event_id: event.event_id),
                build(:batch, name: 'Entrada - Meia', limit_tickets: 20, start_date: 5.days.ago.to_date,
                value: 20.00, end_date: 2.month.from_now.to_date, event_id: event.event_id) ]
    allow(Batch).to receive(:request_batches_by_event_id).and_return(batches)

    visit event_batches_path(event.event_id, locale: :'pt-BR')

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    travel_to(Time.zone.local(2024, 01, 01, 12, 04, 44))
    user = create(:user)
    event = build(:event, name: 'Dev Week')
    events = [ event ]
    batches = [ build(:batch, name: 'Entrada - VIP', limit_tickets: 50, start_date: 2.days.ago.to_date,
                  value: 40.00, end_date: 1.month.from_now.to_date, event_id: event.event_id),
                build(:batch, name: 'Entrada - Meia', limit_tickets: 20, start_date: 5.days.ago.to_date,
                  value: 20.00, end_date: 2.month.from_now.to_date, event_id: event.event_id) ]
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Batch).to receive(:request_batches_by_event_id).and_return(batches)

    login_as(user)
    visit root_path(locale: :'pt-BR')
    click_on 'Eventos'
    click_on 'Dev Week'
    click_on 'Ver ingressos'

    expect(page).to have_content 'Entrada - VIP'
    expect(page).to have_content 'Quantidade: 50', normalize_ws: true
    expect(page).to have_content 'Início de venda: 30 de dezembro de 2023', normalize_ws: true
    expect(page).to have_content 'Clausura de venda: 01 de fevereiro de 2024', normalize_ws: true
    expect(page).to have_content 'Valor: R$ 40', normalize_ws: true
    expect(page).to have_content 'Entrada - Meia'
    expect(page).to have_content 'Quantidade: 20', normalize_ws: true
    expect(page).to have_content 'Início de venda: 27 de dezembro de 2023', normalize_ws: true
    expect(page).to have_content 'Clausura de venda: 01 de março de 2024', normalize_ws: true
    expect(page).to have_content 'Valor: R$ 20', normalize_ws: true
    expect(page).to have_link 'Comprar'
  end

  it "e não vê botão comprar se o tipo de ingresso não iníciou as vendas" do
    travel_to(Time.zone.local(2024, 01, 01, 12, 04, 44))
    user = create(:user)
    event = build(:event, name: 'Dev Week')
    batch_1 =  build(:batch, name: 'Entrada - VIP', limit_tickets: 50, start_date: 2.days.ago.to_date,
                      value: 40.00, end_date: 1.month.from_now.to_date, event_id: event.event_id)
    batch_2 = build(:batch, name: 'Entrada - Meia', limit_tickets: 20, start_date: 5.days.from_now.to_date,
                    value: 20.00, end_date: 2.month.from_now.to_date, event_id: event.event_id)
    batch_3 = build(:batch, name: 'Entrada - PCD', limit_tickets: 20, start_date: 2.month.ago.to_date,
                    value: 20.00, end_date: Date.yesterday, event_id: event.event_id)
    batches = [ batch_1, batch_2, batch_3 ]

    allow(Batch).to receive(:request_batches_by_event_id).and_return(batches)

    login_as(user)
    visit event_batches_path(event.event_id, locale: :'pt-BR')

    expect(page).to have_content 'Entrada - PCD'
    within("#batch_id_#{batch_1.batch_id}") do
       expect(page).to have_link 'Comprar'
    end
    within("#batch_id_#{batch_2.batch_id}") do
       expect(page).not_to have_link 'Comprar'
       expect(page).to have_content 'Vendas em breve'
    end
    within("#batch_id_#{batch_3.batch_id}") do
       expect(page).not_to have_link 'Comprar'
       expect(page).to have_content 'Vendas fechadas'
    end
  end

  it 'e o evento, deve ter ingressos cadastrados' do
    user = create(:user)
    event = build(:event, name: 'Dev Week', batches: [])
    allow(Event).to receive(:request_event_by_id).and_return(event)

    login_as(user)
    visit event_batches_path(event.event_id, locale: :'pt-BR')

    expect(current_path).to eq event_path(event.event_id, locale: :'pt-BR')
    expect(page).to have_content 'Evento ainda não possui ingressos'
  end
end
