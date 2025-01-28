require 'rails_helper'

describe 'Tickets API' do
  context '[GET] /api/v1/batches/[:batch_id]' do
    it 'com sucesso' do
      batches = [
        {
        id: 1,
        name: 'Entrada - Meia',
        limit_tickets: 20,
        start_date: 5.days.ago.to_date,
        value: 20.00,
        end_date: 2.month.from_now.to_date,
        event_id: 1
        },
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
      target_batch_id = batches[1][:id]

      build(:event, name: 'DevWeek',  event_id: 1, batches: batches)
      create(:ticket, batch_id: target_batch_id)
      create(:ticket, batch_id: target_batch_id)

      get "/api/v1/batches/#{target_batch_id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      puts "Params: #{json_response}"
      expect(json_response["sold_tickets"]).to eq 2
      expect(json_response["id"]).to eq 2
    end
  end
end
