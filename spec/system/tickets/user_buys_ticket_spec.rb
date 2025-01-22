require 'rails_helper'

describe 'Usuário é redirecionado para a tela de confimação de compra de ingresso' do
  it 'e visualiza os métodos de pagamento' do
    user = create(:user)
    event = build(:event,  event_id: 1)
    batch = build(:batch, batch_id: 1, name: "Meia-Entrada")

    login_as(user)
    visit new_event_batch_ticket_path(event_id: event.event_id, batch_id: batch.batch_id, locale: :'pt-BR')

    expect(page).to have_content "Pay-Pal"
    expect(page).to have_content "PIX"
    expect(page).to have_content "Cartão De Crédito"
    expect(page).to have_content "Boleto Bancário"
    expect(page).to have_content "Em Dinheiro"
  end

  it 'e realiza compra com sucesso' do
    travel_to(Time.zone.local(2024, 02, 01, 00, 04, 44))
    user = create(:user)
    event_1 = build(:event,  event_id: 1)
    event_2 = build(:event,  event_id: 2)
    batch_1 = build(:batch, batch_id: 1, name: "Meia-Entrada")
    batch_2 = build(:batch, batch_id: 2, name: "Pré-venda")

    login_as(user)
    visit new_event_batch_ticket_path(event_id: event_2.event_id, batch_id: batch_2.batch_id, locale: :'pt-BR')
    select "PIX", from: 'Método de pagamento'
    click_on "Criar Ingresso"

    ticket = Ticket.last

    expect(page).to have_content("Compra aprovada")
    expect(ticket.batch_id).to eq batch_2.batch_id
    expect(ticket.payment_method).to eq 'pix'
  end
end
