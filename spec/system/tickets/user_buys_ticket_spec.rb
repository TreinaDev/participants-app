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
end
