require 'rails_helper'

describe EventsApiService, type: :model do
  describe 'Usuário faz uma requisição para uma lista de eventos' do
    it 'e recebe uma lista de eventos com sucesso' do
      events = [
        {
            uuid: 1,
            name: 'Aprendedo a cozinhar',
            address: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
            participants_limit: 30,
            banner_url: 'https://via.placeholder.com/300x200',
            logo_url: 'https://via.placeholder.com/100x100',
            description: 'Aprenda a fritar um ovo',
            event_owner: 'Samuel',
            schedule: {
              start_date: '2024-01-01',
              end_date:	'2024-02-01'
            }
        },
        {
          uuid: 2,
          name: 'Aprendendo a Nadar',
          address: 'Rua dos Elefantes, 138, CEP: 50000000, Salvador, Bahia, Brasil',
          participants_limit: 40,
          banner_url: 'https://via.placeholder.com/300x200',
          logo_url: 'https://via.placeholder.com/100x100',
          description: 'Aprenda a nadar rápido',
          event_owner: 'Cesar',
          schedule: {
            start_date:	"2025-02-01T12:00:00.000-03:00",
            end_date:	"2025-02-04T12:00:00.000-03:00"
          }
        }
      ]

      response = double('response', status: 200, body: events.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events').and_return(response)
      results = EventsApiService.get_events

      expect(results[0][:uuid]).to eq 1
      expect(results[0][:name]).to eq 'Aprendedo a cozinhar'
      expect(results[0][:address]).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(results[0][:participants_limit]).to eq 30
      expect(results[0][:banner_url]).to eq 'https://via.placeholder.com/300x200'
      expect(results[0][:logo_url]).to eq 'https://via.placeholder.com/100x100'
      expect(results[0][:description]).to eq 'Aprenda a fritar um ovo'
      expect(results[0][:event_owner]).to eq 'Samuel'
      expect(results[0][:schedule][:start_date]).to eq '2024-01-01'
      expect(results[0][:schedule][:end_date]).to eq '2024-02-01'

      expect(results[1][:uuid]).to eq 2
      expect(results[1][:name]).to eq 'Aprendendo a Nadar'
      expect(results[1][:address]).to eq 'Rua dos Elefantes, 138, CEP: 50000000, Salvador, Bahia, Brasil'
      expect(results[1][:participants_limit]).to eq 40
      expect(results[1][:banner_url]).to eq 'https://via.placeholder.com/300x200'
      expect(results[1][:logo_url]).to eq 'https://via.placeholder.com/100x100'
      expect(results[1][:description]).to eq 'Aprenda a nadar rápido'
      expect(results[1][:event_owner]).to eq 'Cesar'
      expect(results[1][:schedule][:start_date]).to eq "2025-02-01T12:00:00.000-03:00"
      expect(results[1][:schedule][:end_date]).to eq "2025-02-04T12:00:00.000-03:00"
    end

    it 'com query strings' do
      events = [
        {
            uuid: 1,
            name: 'Aprendedo a cozinhar',
            address: 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
            participants_limit: 30,
            banner_url: 'https://via.placeholder.com/300x200',
            logo_url: 'https://via.placeholder.com/100x100',
            description: 'Aprenda a fritar um ovo',
            event_owner: 'Samuel',
            start_date: '2024-01-01',
            end_date:	'2024-02-01'
        },
        {
          uuid: 2,
          name: 'Aprendendo a Nadar',
          address: 'Rua dos Elefantes, 138, CEP: 50000000, Salvador, Bahia, Brasil',
          participants_limit: 40,
          banner_url: 'https://via.placeholder.com/300x200',
          logo_url: 'https://via.placeholder.com/100x100',
          description: 'Aprenda a nadar rápido',
          event_owner: 'Cesar',
          start_date:	"2025-02-01T12:00:00.000-03:00",
          end_date:	"2025-02-04T12:00:00.000-03:00"
        }
      ]
      response = double('response', status: 200, body: [ events[0] ].to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events?query=cozinhar').and_return(response)
      results = EventsApiService.get_events('cozinhar')

      expect(results.length).to eq 1
      expect(results[0][:uuid]).to eq 1
      expect(results[0][:name]).to eq 'Aprendedo a cozinhar'
      expect(results[0][:address]).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(results[0][:participants_limit]).to eq 30
      expect(results[0][:banner_url]).to eq 'https://via.placeholder.com/300x200'
      expect(results[0][:logo_url]).to eq 'https://via.placeholder.com/100x100'
      expect(results[0][:description]).to eq 'Aprenda a fritar um ovo'
      expect(results[0][:event_owner]).to eq 'Samuel'
      expect(results[0][:start_date]).to eq '2024-01-01'
      expect(results[0][:end_date]).to eq '2024-02-01'
    end

    it 'e ocorre erro na requisição' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events').and_raise(Faraday::Error)
      expect { EventsApiService.get_events }.to raise_error(Faraday::Error)
    end
  end

  describe 'Usuário faz uma requisição para um evento' do
    it 'e recebe um evento com sucesso' do
      event = {
        uuid:	"1",
        name:	'Aprendedo a cozinhar',
        description:	'Aprenda a fritar um ovo',
        address:	'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        banner_url:	'https://via.placeholder.com/300x200',
        logo_url: 'https://via.placeholder.com/100x100',
        participants_limit:	30,
        event_owner:	'Samuel',
        start_date:	"2025-02-01T12:00:00.000-03:00",
        end_date:	"2025-02-04T12:00:00.000-03:00",
        schedules: {
          date: "2025-02-01",
          schedule_items: [
            {
              code: 'AAAAA',
              name: 'PROVA',
              description: 'VALENDO 10',
              start_time: '2025-02-02T12:00:00.000-03:00',
              end_time: '2025-02-02T12:00:00.000-03:00',
              responsible_name: 'Palestrante',
              responsible_email:  'palestrante@email',
              schedule_type: 'activity'
            }
          ]
        }
      }

      response = double('response', status: 200, body: event.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1').and_return(response)
      result = EventsApiService.get_event_by_id(event[:uuid])

      expect(result[:name]).to eq 'Aprendedo a cozinhar'
      expect(result[:address]).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(result[:participants_limit]).to eq 30
      expect(result[:banner_url]).to eq 'https://via.placeholder.com/300x200'
      expect(result[:logo_url]).to eq 'https://via.placeholder.com/100x100'
      expect(result[:description]).to eq 'Aprenda a fritar um ovo'
      expect(result[:event_owner]).to eq 'Samuel'
      expect(result[:schedules][:date]).to eq "2025-02-01"
      expect(result[:schedules][:schedule_items][0][:code]).to eq "AAAAA"
      expect(result[:schedules][:schedule_items][0][:name]).to eq "PROVA"
      expect(result[:schedules][:schedule_items][0][:description]).to eq "VALENDO 10"
      expect(result[:schedules][:schedule_items][0][:start_time]).to eq "2025-02-02T12:00:00.000-03:00"
      expect(result[:schedules][:schedule_items][0][:end_time]).to eq "2025-02-02T12:00:00.000-03:00"
      expect(result[:schedules][:schedule_items][0][:responsible_name]).to eq "Palestrante"
      expect(result[:schedules][:schedule_items][0][:responsible_email]).to eq "palestrante@email"
      expect(result[:schedules][:schedule_items][0][:schedule_type]).to eq "activity"
    end
  end

  it 'e ocorre erro na requisição' do
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1').and_raise(Faraday::Error)

    expect { EventsApiService.get_event_by_id(1) }.to raise_error(Faraday::Error)
  end
end

describe 'Requisição para um comunicado de um evento' do
  it 'e recebe um comunicado com sucesso' do
    announcement = {
      id: 1,
      title: 'PAGUEM A TAXA',
      description: 'PAGUEM LOGO',
      event_id: 1

    }
    response = double('response', status: 200, body: announcement.to_json)
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1/announcements/1').and_return(response)
    result = EventsApiService.get_announcement_by_id(announcement[:event_id], announcement[:id])

    expect(result[:id]).to eq 1
    expect(result[:title]).to eq 'PAGUEM A TAXA'
    expect(result[:description]).to eq 'PAGUEM LOGO'
    expect(result[:event_id]).to eq 1
  end

  it 'e ocorre erro na requisição' do
    allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1/announcements/1').and_raise(Faraday::Error)

    expect { EventsApiService.get_announcement_by_id(1, 1) }.to raise_error(Faraday::Error)
  end
end
