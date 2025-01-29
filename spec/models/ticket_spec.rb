require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe '#valid?' do
    it 'é válido e possui um token' do
      user = create(:user)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")
      allow(SecureRandom).to receive(:alphanumeric).with(36).and_return("qQFcXk2K1AL9Ciditu3pbOLE4TyokgcYElAR")

      ticket = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        event_id: batch.event_id,
        payment_method: 'pix',
      )
      expect(ticket.token).to be_present
      expect(ticket.token).to eq "qQFcXk2K1AL9Ciditu3pbOLE4TyokgcYElAR"
    end

    it 'e deve ter a data de compra' do
      travel_to(Time.zone.local(2024, 02, 01, 00, 04, 44))
      user = create(:user)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")

      ticket = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        event_id: batch.event_id,
        payment_method: 'pix',
      )
      expect(ticket.date_of_purchase).to be_present
      expect(ticket.date_of_purchase.year).to eq 2024
      expect(ticket.date_of_purchase.month).to eq 2
      expect(ticket.date_of_purchase.day).to eq 1
    end

    it 'é inválido sem um método de pagamento' do
      user = create(:user)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")

      ticket = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        event_id: batch.event_id
      )

      expect(ticket).not_to be_valid
    end

    it 'é invalido com token já utilizado antes' do
      user = create(:user)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")
      same_token = "qQFcXk2K1AL9Ciditu3pbOLE4TyokgcYElAR"

      allow(SecureRandom).to receive(:alphanumeric).with(36).and_return(same_token)

      ticket_1 = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        event_id: batch.event_id,
        payment_method: 'pix',
      )

      allow(SecureRandom).to receive(:alphanumeric).with(36).and_return(same_token)

      ticket_2 = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        payment_method: 'pix',
      )

      expect(ticket_1).to be_valid
      expect(ticket_2).not_to be_valid
    end

    it 'é inválido com um token com menos de 36 caracteres' do
      user = create(:user)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")
      short_token = "qQ"
      allow(SecureRandom).to receive(:alphanumeric).with(36).and_return(short_token)

      ticket = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        payment_method: 'pix',
      )
      expect(ticket).not_to be_valid
    end

    it 'e recebe status de confirmado' do
      user = create(:user)
      batch = build(:batch, batch_id: 1, name: "Meia-Entrada")

      ticket = Ticket.create(
        user: user,
        batch_id: batch.batch_id,
        event_id: batch.event_id,
        payment_method: 'pix',
      )
      expect(ticket.status_confirmed?).to eq true
    end
  end
end
