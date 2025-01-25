require "rails_helper"

RSpec.describe RemindersMailer, type: :job do
  describe "#ticket_reminder" do
    it "envia o email" do
      ActiveJob::Base.queue_adapter = :test
      event = build(:event, name: 'Evento Teste 01')
      allow(Event).to receive(:request_event_by_id).and_return(event)
      expect {
        RemindersMailer.with(user: 1, event: 1).ticket_reminder.deliver_later(wait_until: 1.day.from_now.to_datetime)
      }.to have_enqueued_job
    end
  end
end
