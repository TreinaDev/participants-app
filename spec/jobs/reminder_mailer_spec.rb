require "rails_helper"

RSpec.describe RemindersMailer, type: :job do
  describe "#ticket_reminder" do
    it "envia o email" do
      user = create(:user)
      event = build(:event, name: 'Evento Teste 01')
      allow(Event).to receive(:request_event_by_id).and_return(event)

      RemindersMailer.with(user: user.id, event: event.event_id).ticket_reminder.deliver

      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it "não enfileira o e-mail para usuário inválido" do
      invalid_user_id = 9999
      event = build(:event)
      allow(Event).to receive(:request_event_by_id).and_return(event)

      expect {
        RemindersMailer.with(user: invalid_user_id, event: event.event_id).ticket_reminder.deliver
      }.not_to have_enqueued_mail(RemindersMailer, :ticket_reminder)

      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "não enfileira o e-mail para evento inválido" do
      user = create(:user)
      allow(Event).to receive(:request_event_by_id).and_return(nil)

      expect {
        RemindersMailer.with(user: user.id, event: 999).ticket_reminder.deliver
      }.not_to have_enqueued_mail(RemindersMailer, :ticket_reminder)

      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
