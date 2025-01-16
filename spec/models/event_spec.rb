require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validações" do
    it "e retorna detalhes do evento" do
      event = {
        event_id: 1,
        name: 'Aprendedo a cozinhar',
        url_event: 'https://ecvitoria.com.br/public/Inicio/',
        local_event: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        limit_participants: 30,
        banner: 'https://via.placeholder.com/300x200',
        logo: 'https://via.placeholder.com/100x100',
        description: 'Aprenda a fritar um ovo',
        price: 30,
        event_owner: 'Samuel',
        event_agendas: []
      }

      response = double('response', status: 200, body: event.to_json)
      allow(Faraday).to receive(:get).with('http://localhost:3000/events/1').and_return(response)
      allow(response).to receive(:success?).and_return(true)
      result = Event.request_event_by_id(event[:event_id])

      # Assert
      expect(result.name).to eq 'Aprendedo a cozinhar'
      expect(result.url_event).to eq 'https://ecvitoria.com.br/public/Inicio/'
      expect(result.local_event).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(result.limit_participants).to eq 30
      expect(result.banner).to eq 'https://via.placeholder.com/300x200'
      expect(result.logo).to eq 'https://via.placeholder.com/100x100'
      expect(result.description).to eq 'Aprenda a fritar um ovo'
      expect(result.event_owner).to eq 'Samuel'
      expect(result.event_agendas).to eq []
    end

  end
  
end