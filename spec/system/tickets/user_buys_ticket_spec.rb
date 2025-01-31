require 'rails_helper'

describe 'Usuário é redirecionado para a tela de confimação de compra de ingresso' do
  it 'e visualiza os métodos de pagamento' do
    travel_to(Time.zone.local(2024, 02, 01, 00, 04, 44))
    batches = [ {
      code: '1',
      name: 'Entrada - Meia',
      tickets_limit: 20,
      start_date: 5.days.ago.to_date,
      ticket_price: 20.00,
      end_date: 2.month.from_now.to_date,
      event_id: '1'
      }
    ]
    user = create(:user)
    event = build(:event, name: 'DevWeek',  event_id: '1', batches: batches)
    events = [ event ]
    allow(Event).to receive(:all).and_return(events)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Batch).to receive(:request_batches_by_event_id).and_return(event.batches)
    allow(Batch).to receive(:check_if_batch_is_sold_out).and_return(false)

    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Eventos'
    end
    click_on 'DevWeek'
    click_on 'Ver Ingressos'
    click_on 'Comprar'

    expect(page).to have_content "Pay-Pal"
    expect(page).to have_content "PIX"
    expect(page).to have_content "Cartão De Crédito"
    expect(page).to have_content "Boleto Bancário"
    expect(page).to have_content "Em Dinheiro"
  end

  it 'e realiza compra com sucesso' do
    travel_to(Time.zone.local(2024, 02, 01, 00, 04, 44))
    user = create(:user)
    event_1 = build(:event,  event_id: '1')
    event_2 = build(:event, name: 'DevWeek',  event_id: '2')
    batch_1 = build(:batch, batch_id: '1', name: "Meia-Entrada")
    batch_2 = build(:batch, batch_id: '2', name: "Pré-venda")
    allow(Batch).to receive(:check_if_batch_is_sold_out).and_return(false)

    allow(Event).to receive(:request_event_by_id).and_return(event_2)

    login_as(user)
    visit new_event_batch_ticket_path(event_id: event_2.event_id, batch_id: batch_2.batch_id, locale: :'pt-BR')
    select "PIX", from: 'Método de pagamento'
    click_on "Criar Ingresso"

    ticket = Ticket.last

    expect(page).to have_content("Compra aprovada")
    expect(page).to have_content 'Evento: DevWeek'
    expect(ticket.batch_id).to eq batch_2.batch_id
    expect(ticket.payment_method).to eq 'pix'
    expect(page).to have_css('svg')
  end

  it 'e falha por não selecionar o método de pagamento' do
    user = create(:user)
    event_1 = build(:event,  event_id: '1')
    event_2 = build(:event,  event_id: '2')
    batch_1 = build(:batch, batch_id: '1', name: "Meia-Entrada")
    batch_2 = build(:batch, batch_id: '2', name: "Pré-venda")
    allow(Batch).to receive(:check_if_batch_is_sold_out).and_return(false)

    login_as(user)
    visit new_event_batch_ticket_path(event_id: event_2.event_id, batch_id: batch_2.batch_id, locale: :'pt-BR')
    click_on "Criar Ingresso"

    expect(page).not_to have_content("Compra aprovada")
    expect(page).to have_content "Não foi possível realizar a compra"
    expect(page).to have_content "Método de pagamento não pode ficar em branco"
  end
end
