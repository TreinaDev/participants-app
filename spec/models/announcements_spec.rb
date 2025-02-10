require 'rails_helper'

RSpec.describe Announcement, type: :model do
  context 'Requisição para listar comunicados de um evento' do
    it "com sucesso" do
      event = build(:event)
      announcements = { announcements:
        [
          {
            title: 'PAGUEM A TAXA',
            description: 'PAGUEM LOGO',
            code: "ABDJDS",
            created_at: "2025-02-01T12:00:00.000-03:00"
          },
          {
            title: 'LUTAS DE SUMÔ',
            description: 'ARTES MARCIAIS SERÃO PARTE DO EVENTO',
            code: "ABDJDT",
            created_at: "2025-02-02T12:00:00.000-03:00"
          }
        ]
       }

      response = double('response', status: 200, body: announcements.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3001/api/v1/events/#{event.event_id}/announcements").and_return(response)
      result = Announcement.request_announcements_by_event_id(event.event_id)

      expect(result[0].title).to eq 'PAGUEM A TAXA'
      expect(result[0].description).to eq 'PAGUEM LOGO'
      expect(result[0].announcement_id).to eq "ABDJDS"
      expect(result[0].created_at).to eq "2025-02-01T12:00:00.000-03:00"

      expect(result[1].title).to eq 'LUTAS DE SUMÔ'
      expect(result[1].description).to eq 'ARTES MARCIAIS SERÃO PARTE DO EVENTO'
      expect(result[1].announcement_id).to eq "ABDJDT"
      expect(result[1].created_at).to eq "2025-02-02T12:00:00.000-03:00"
    end

    it "e retorna um array vazio, caso a API retorne status 500" do
      event = build(:event)

      response = double('response', status: 500, body: "{}")
      allow(Faraday).to receive(:get).with("http://localhost:3001/api/v1/events/#{event.event_id}/announcements").and_return(response)
      allow(Rails.logger).to receive(:error)

      result = Announcement.request_announcements_by_event_id(event.event_id)

      expect(result).to eq []
      expect(Rails.logger).to have_received(:error)
    end
  end

  context 'Requisição para receber um comunicado específico de um evento' do
    it "com sucesso" do
      event = build(:event)

      announcement = { announcement:
        {
          title: 'PAGUEM A TAXA',
          description: 'PAGUEM LOGO',
          code: "ABDJDS",
          created_at: "2025-02-01T12:00:00.000-03:00"
        }
      }

      response = double('response', status: 200, body: announcement.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3001/api/v1/events/#{event.event_id}/announcements/#{announcement[:code]}").and_return(response)
      result = Announcement.request_announcement_by_id(event.event_id, announcement[:code])

      expect(result.title).to eq 'PAGUEM A TAXA'
      expect(result.description).to eq 'PAGUEM LOGO'
      expect(result.announcement_id).to eq "ABDJDS"
      expect(result.created_at).to eq "2025-02-01T12:00:00.000-03:00"
    end

    it "e retorna um array vazio, caso a API retorne status 500" do
      event = build(:event)

      response = double('response', status: 500, body: "{}")
      allow(Faraday).to receive(:get).with("http://localhost:3001/api/v1/events/#{event.event_id}/announcements/ABDJDS").and_return(response)
      allow(Rails.logger).to receive(:error)

      result = Announcement.request_announcement_by_id(event.event_id, "ABDJDS")

      expect(result).to eq nil
      expect(Rails.logger).to have_received(:error)
    end
  end
end
