require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'detalhes de um evento' do
    it "e retorna detalhes do evento" do
      travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
      event = {
        uuid:	"1",
        name:	'Aprendedo a cozinhar',
        description:	'Aprenda a fritar um ovo',
        address:	'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        banner_url:	'https://via.placeholder.com/300x200',
        logo_url: 'https://via.placeholder.com/100x100',
        participants_limit:	30,
        event_owner:	'Samuel',
        schedule: {
          start_date:	"2025-02-01T12:00:00.000-03:00",
          end_date:	"2025-02-04T12:00:00.000-03:00"
        }
      }

      response = double('response', status: 200, body: event.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1').and_return(response)
      result = Event.request_event_by_id(event[:uuid])

      expect(result.event_id).to eq '1'
      expect(result.name).to eq 'Aprendedo a cozinhar'
      expect(result.local_event).to eq 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil'
      expect(result.limit_participants).to eq 30
      expect(result.banner).to eq 'https://via.placeholder.com/300x200'
      expect(result.logo).to eq 'https://via.placeholder.com/100x100'
      expect(result.description).to eq 'Aprenda a fritar um ovo'
      expect(result.event_owner).to eq 'Samuel'
      expect(result.start_date).to eq "2025-02-01T12:00:00.000-03:00".to_date
      expect(result.end_date).to eq "2025-02-04T12:00:00.000-03:00".to_date
    end

    it "e retorna detalhes do evento com agenda" do
      travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
      event_agendas = [ {
        event_agenda_id: 1,
        date: '15/08/2025',
        title: 'Aprendendo a cozinhar massas',
        description: 'lorem ipsum',
        instructor: 'Elefante',
        email: 'elefante@email.com',
        start_time: '07:00',
        duration: 120,
        agenda_type: 'Palestra',
        start_date: '2024-01-01',
        end_date: '2024-02-01'
      }, {
        event_agenda_id: 2,
        date: '15/08/2025',
        title: 'Aprendendo a fritar salgados',
        description: 'lorem ipsum',
        instructor: 'Jacaré',
        email: 'jacare@email.com',
        start_time: '11:00',
        duration: 120,
        agenda_type: 'Work-shop',
        start_date: '2024-01-01',
        end_date: '2024-02-01'
      }
      ]
      event = {
        uuid:	"1",
        name:	'Aprendedo a cozinhar',
        description:	'Aprenda a fritar um ovo',
        address:	'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        banner_url:	'https://via.placeholder.com/300x200',
        logo_url: 'https://via.placeholder.com/100x100',
        participants_limit:	30,
        event_owner:	'Samuel',
        schedule: {
          start_date:	"2025-02-01T12:00:00.000-03:00",
          end_date:	"2025-02-04T12:00:00.000-03:00"
        },
        event_agendas: event_agendas
      }
      response = double('response', status: 200, body: event.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1').and_return(response)
      result = Event.request_event_by_id(event[:uuid])


      expect(result.event_agendas[0].event_agenda_id).to eq 1
      expect(result.event_agendas[0].date).to eq '15/08/2025'
      expect(result.event_agendas[0].title).to eq 'Aprendendo a cozinhar massas'
      expect(result.event_agendas[0].description).to eq 'lorem ipsum'
      expect(result.event_agendas[0].instructor).to eq 'Elefante'
      expect(result.event_agendas[0].email).to eq 'elefante@email.com'
      expect(result.event_agendas[0].start_time).to eq '07:00'
      expect(result.event_agendas[0].duration).to eq 120
      expect(result.event_agendas[0].type).to eq 'Palestra'

      expect(result.event_agendas[1].event_agenda_id).to eq 2
      expect(result.event_agendas[1].date).to eq '15/08/2025'
      expect(result.event_agendas[1].title).to eq 'Aprendendo a fritar salgados'
      expect(result.event_agendas[1].description).to eq 'lorem ipsum'
      expect(result.event_agendas[1].instructor).to eq 'Jacaré'
      expect(result.event_agendas[1].email).to eq 'jacare@email.com'
      expect(result.event_agendas[1].start_time).to eq '11:00'
      expect(result.event_agendas[1].duration).to eq 120
      expect(result.event_agendas[1].type).to eq 'Work-shop'
    end

    it "e retorna um array vazio, caso a API retorne status 500" do
      response = double('response', status: 500, body: "{}")
      allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/events/1').and_return(response)
      allow(Rails.logger).to receive(:error)

      result = Event.request_event_by_id("1")

      expect(result).to eq nil
      expect(Rails.logger).to have_received(:error)
    end
  end

  context 'lista de eventos' do
    it 'Deveria receber toda a lista de eventos disponíveis' do
      travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
      json = File.read(Rails.root.join('spec/support/json/events_list.json'))
      url = 'http://localhost:3000/api/v1/events'
      response = double('faraday_response', body: json, status: 200)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(true)

      result = Event.all

      expect(result.length).to eq 2
      expect(result[0].event_id).to eq "1"
      expect(result[0].name).to eq 'Dev Week'
      expect(result[0].banner).to eq "http://localhost:3000/events/1/banner.jpg"
      expect(result[0].logo).to eq "http://localhost:3000/events/1/logo.jpg"
      expect(result[1].event_id).to eq "2"
      expect(result[1].name).to eq 'Ruby Update'
      expect(result[1].banner).to eq "http://localhost:3000/events/2/banner.jpg"
      expect(result[1].logo).to eq "http://localhost:3000/events/2/logo.jpg"
    end

    it 'e deveria receber array vazio em caso de erro na requisição' do
      url = 'http://localhost:3000/api/v1/events/'
      response = double('faraday_response', body: "{}", status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(false)

      result = Event.all
      expect(result.length).to eq 0
    end

    it 'só recebe eventos que não aconteceram' do
      travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
      json = File.read(Rails.root.join('spec/support/json/error_events_list.json'))
      url = 'http://localhost:3000/api/v1/events'
      response = double('faraday_response', body: json, status: 200)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(true)

      result = Event.all

      expect(result.length).to eq 2
    end
  end
end
