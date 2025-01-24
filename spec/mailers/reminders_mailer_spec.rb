require 'rails_helper'

RSpec.describe RemindersMailer, type: :mailer do
  context '#ticket_reminder' do
    it 'envia email para o usuário' do
      user = create(:user, email: 'xablau@gmail.com', name: 'Xablilson')
      event = build(:event, name: 'DevWeek')

      mail = RemindersMailer.with(user: user.id, event: event.event_id).ticket_reminder
      allow(Event).to receive(:request_event_by_id).and_return(event)

      expect(mail.subject).to eq "Lembrete de venda de ingresso"
      expect(mail.to).to eq [ "xablau@gmail.com" ]
      expect(mail.from).to eq [ "ingressos@contato.com" ]
    end

    it 'contém os detalhes do evento' do
      user = create(:user, email: 'xablau@gmail.com', name: 'Xablilson')
      event = build(:event, name: 'DevWeek')

      mail = RemindersMailer.with(user: user.id, event: event.event_id).ticket_reminder
      allow(Event).to receive(:request_event_by_id).and_return(event)

      expect(mail.body).to include "Olá #{user.name}"
      expect(mail.body).to include "O ingresso para o evento #{event.name} chegou"
      expect(mail.body).to include "Garanta já o seu!"
    end
  end
end
