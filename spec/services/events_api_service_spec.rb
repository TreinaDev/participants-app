require 'rails_helper'

describe EventsApiService, type: :model do
  describe 'Usuário faz uma requisição para uma lista de eventos' do 
    it 'e recebe uma lista de eventos com sucesso' do
      events = [{
            event_id: 1,
            name: 'Aprendedo a cozinhar',
            url_event: 'https://ecvitoria.com.br/public/Inicio/',
            local_event: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
            limit_participants: 30,
            banner: 'https://via.placeholder.com/300x200',
            logo: 'https://via.placeholder.com/100x100',
            description: 'Aprenda a fritar um ovo',
            event_owner: 'Samuel',
            event_agendas: [],
            start_date: '2024-01-01',
            end_date: '2024-02-01'
        },
        {
          event_id: 2,
          name: 'Aprendendo a Nadar',
          url_event: 'https://ecbahia.com.br/public/Inicio/',
          local_event: 'Rua dos Elefantes, 138, CEP: 50000000, Salvador, Bahia, Brasil',
          limit_participants: 40,
          banner: 'https://via.placeholder.com/300x200',
          logo: 'https://via.placeholder.com/100x100',
          description: 'Aprenda a nadar rápido',
          event_owner: 'Cesar',
          event_agendas: [],
          start_date: '2024-02-01',
          end_date: '2024-03-01'
        }
      ]
  
  
      response = double('response', status: 200, body: events.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/events').and_return(response)
      results = EventsApiService.get_events
  
      

      expect(results[0][:name]).to eq 'Aprendedo a cozinhar'
      expect(results[0][:url_event]).to eq 'https://ecvitoria.com.br/public/Inicio/'
      expect(results[0][:local_event]).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(results[0][:limit_participants]).to eq 30
      expect(results[0][:banner]).to eq 'https://via.placeholder.com/300x200'
      expect(results[0][:logo]).to eq 'https://via.placeholder.com/100x100'
      expect(results[0][:description]).to eq 'Aprenda a fritar um ovo'
      expect(results[0][:event_owner]).to eq 'Samuel'
      expect(results[0][:event_agendas]).to eq []

      expect(results[1][:name]).to eq 'Aprendendo a Nadar'
      expect(results[1][:url_event]).to eq 'https://ecbahia.com.br/public/Inicio/'
      expect(results[1][:local_event]).to eq 'Rua dos Elefantes, 138, CEP: 50000000, Salvador, Bahia, Brasil'
      expect(results[1][:limit_participants]).to eq 40
      expect(results[1][:banner]).to eq 'https://via.placeholder.com/300x200'
      expect(results[1][:logo]).to eq 'https://via.placeholder.com/100x100'
      expect(results[1][:description]).to eq 'Aprenda a nadar rápido'
      expect(results[1][:event_owner]).to eq 'Cesar'
      expect(results[1][:event_agendas]).to eq []
  
  
    end
  
    it 'e ocorre erro na requisição' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/events').and_raise(Faraday::Error)
      expect { EventsApiService.get_events }.to raise_error(Faraday::Error)
    end
  end

  describe 'Usuário faz uma requisição para um evento' do
    it 'e recebe um evento com sucesso' do
      event = {
        event_id: 1,
        name: 'Aprendedo a cozinhar',
        url_event: 'https://ecvitoria.com.br/public/Inicio/',
        local_event: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        limit_participants: 30,
        banner: 'https://via.placeholder.com/300x200',
        logo: 'https://via.placeholder.com/100x100',
        description: 'Aprenda a fritar um ovo',
        event_owner: 'Samuel',
        event_agendas: [],
        start_date: '2024-01-01',
        end_date: '2024-02-01'
      }

      response = double('response', status: 200, body: event.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/events/1').and_return(response)
      result = EventsApiService.get_event_by_id(event[:event_id])

      expect(result[:name]).to eq 'Aprendedo a cozinhar'
      expect(result[:url_event]).to eq 'https://ecvitoria.com.br/public/Inicio/'
      expect(result[:local_event]).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(result[:limit_participants]).to eq 30
      expect(result[:banner]).to eq 'https://via.placeholder.com/300x200'
      expect(result[:logo]).to eq 'https://via.placeholder.com/100x100'
      expect(result[:description]).to eq 'Aprenda a fritar um ovo'
      expect(result[:event_owner]).to eq 'Samuel'
      expect(result[:event_agendas]).to eq []
    end

  end

  it 'e ocorre erro na requisição' do
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/events/1').and_raise(Faraday::Error)
    expect { EventsApiService.get_event_by_id(1) }.to raise_error(Faraday::Error)
  end

  
end