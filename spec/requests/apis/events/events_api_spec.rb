require 'rails_helper'

describe 'Event API' do
  context 'Retorna quantidade de participantes por evento' do
    it 'com sucesso' do
      batches = [
        {
          id: 1,
          name: 'Entrada - Meia',
          limit_tickets: 20,
          start_date: 5.days.ago.to_date,
          value: 20.00,
          end_date: 2.month.from_now.to_date,
          event_id: '1'
        },
        {
          id: 2,
          name: 'PCD - Meia',
          limit_tickets: 50,
          start_date: 6.days.ago.to_date,
          value: 10.00,
          end_date: 2.month.from_now.to_date,
          event_id: '1'
        }
      ]
      target_batch = batches[1]
      event = build(:event, name: 'DevWeek',  event_id: '1', batches: batches)
      create(:ticket, batch_id: target_batch[:id])
      create(:ticket, batch_id: target_batch[:id])
      create(:ticket, batch_id: target_batch[:id])
      allow(Event).to receive(:request_event_by_id).and_return(event)

      get "/api/v1/events/#{event.event_id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response["id"]).to eq event.event_id
      expect(json_response["sold_tickets"]).to eq 3
    end

    it 'e retorna 404 quando não encontra o Evento' do
      batches = [
        {
          id: 2,
          name: 'PCD - Meia',
          limit_tickets: 50,
          start_date: 6.days.ago.to_date,
          value: 10.00,
          end_date: 2.month.from_now.to_date,
          event_id: 1
        }
      ]
      build(:event, name: 'DevWeek',  event_id: 1, batches: batches)
      target_batch = batches[0]
      create(:ticket, batch_id: target_batch[:id])
      invalid_event_id = 12345678
      allow(Event).to receive(:request_event_by_id).and_return(nil)

      get "/api/v1/events/#{invalid_event_id}"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Event not found'
    end

    it 'e não conta participantes de outro evento' do
      batches = [
        {
          id: 1,
          name: 'Entrada - Meia',
          limit_tickets: 20,
          start_date: 5.days.ago.to_date,
          value: 20.00,
          end_date: 2.month.from_now.to_date,
          event_id: '1'
        }
      ]
      other_batches = [
        {
          id: 2,
          name: 'PCD - Meia',
          limit_tickets: 50,
          start_date: 6.days.ago.to_date,
          value: 10.00,
          end_date: 2.month.from_now.to_date,
          event_id: '2'
        }
      ]
      target_batch = batches[0]
      other_batch= other_batches[0]
      event = build(:event, name: 'DevWeek',  event_id: '1', batches: batches)
      build(:event, name: 'Tailwind',  event_id: '2', batches: other_batches)
      create(:ticket, batch_id: target_batch[:id], event_id: '1')
      create(:ticket, batch_id: target_batch[:id], event_id: '1')
      create(:ticket, batch_id: other_batch[:id], event_id: '2')


      allow(Event).to receive(:request_event_by_id).and_return(event)

      get "/api/v1/events/#{event.event_id}"


      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response["sold_tickets"]).to eq 2
      expect(json_response["id"]).to eq '1'
    end

    it 'E falha com um erro interno' do
      batches = [
        {
        id: 2,
        name: 'PCD - Meia',
        limit_tickets: 50,
        start_date: 6.days.ago.to_date,
        value: 10.00,
        end_date: 2.month.from_now.to_date,
        event_id: 1
        }
      ]
      target_batch = batches[0]
      event = build(:event, name: 'DevWeek',  event_id: '1', batches: batches)
      create(:ticket, batch_id: target_batch[:id])
      invalid_event_id = 12345678
      allow(Ticket).to receive(:where).and_raise(ActiveRecord::QueryCanceled)
      allow(Event).to receive(:request_event_by_id).and_return(event)

      get "/api/v1/events/#{invalid_event_id}"

      expect(response.status).to eq 500
    end
  end
end
