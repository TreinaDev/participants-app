require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Informações de eventos' do
    context 'lista de eventos' do
      it 'Deveria receber toda a lista de eventos disponíveis' do
        travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
        json = File.read(Rails.root.join('spec/support/json/events_for_sale_list.json'))
        url = 'https://localhost:3000/events'
        response = double('faraday_response', body: json, status: 200)
        allow_any_instance_of(Faraday::Connection).to receive(:get).with(url).and_return(response)
        allow(response).to receive(:success?).and_return(true)

        result = Event.all

        expect(result.length).to eq 2
        expect(result[0].event_id).to eq 1
        expect(result[0].name).to eq 'Dev Week'
        expect(result[0].banner).to eq "http://localhost:3000/events/1/banner.jpg"
        expect(result[0].logo).to eq "http://localhost:3000/events/1/logo.jpg"
        expect(result[1].event_id).to eq 2
        expect(result[1].name).to eq 'Ruby Update'
        expect(result[1].banner).to eq "http://localhost:3000/events/2/banner.jpg"
        expect(result[1].logo).to eq "http://localhost:3000/events/2/logo.jpg"
      end

      it 'e deveria receber array vazio em caso de erro na requisição' do
        url = 'https://localhost:3000/events'
        response = double('faraday_response', body: "{}", status: 500)
        allow(Faraday).to receive(:get).with(url).and_return(response)
        allow(response).to receive(:success?).and_return(false)

        result = Event.all
        expect(result.length).to eq 0
      end

      it 'só recebe eventos que já aconteceram' do
        travel_to(Time.zone.local(2024, 01, 01, 00, 04, 44))
        json = File.read(Rails.root.join('spec/support/json/error_events_list.json'))
        url = 'https://localhost:3000/events'
        response = double('faraday_response', body: json, status: 200)
        allow_any_instance_of(Faraday::Connection).to receive(:get).with(url).and_return(response)
        allow(response).to receive(:success?).and_return(true)

        result = Event.all

        expect(result.length).to eq 2
      end
    end
  end
end
