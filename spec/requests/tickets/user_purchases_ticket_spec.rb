require 'rails_helper'
RSpec.describe "Tickets", type: :request do
  describe 'Usuário vê opções de pagamento' do
    it 'e deve estar autenticado' do
      event = build(:event,  event_id: 1)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")

      get(new_event_batch_ticket_path(batch_id: batch.batch_id, event_id: event.event_id))

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(response).to have_http_status(302)
    end
  end

  describe 'Usuário escolhe método de pagamento' do
    it 'e deve estar autenticado' do
      event = build(:event,  event_id: 1)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")

      post(event_batch_tickets_path(batch_id: batch.batch_id, event_id: event.event_id), params: { ticket: { payment_method: :cash } })

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(response).to have_http_status(302)
    end
  end
end
