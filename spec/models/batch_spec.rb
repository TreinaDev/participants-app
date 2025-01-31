require 'rails_helper'

RSpec.describe Batch, type: :model do
  context 'Tipos de ingresso' do
    it "e retorna Tipos de ingresso" do
      travel_to(Time.zone.local(2024, 01, 01, 12, 04, 44))
      batches = [
        {
          code: '1',
          name: 'Entrada - VIP',
          tickets_limit: 50,
          start_date: '2024-12-30',
          ticket_price: 40.00,
          end_date: '2024-02-01',
          event_id: '1'
        },
        {
          id: '2',
          name: 'Entrada - Meia',
          tickets_limit: 20,
          start_date: '2024-12-27',
          ticket_price: 20.00,
          end_date: '2024-03-01',
          event_id: '1'
        }
      ]

      event = {
        code:	"1",
        name:	'Aprendedo a cozinhar',
        description:	'Aprenda a fritar um ovo',
        address:	'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        banner_url:	'https://via.placeholder.com/300x200',
        logo_url: 'https://via.placeholder.com/100x100',
        participants_limit:	30,
        event_owner:	'Samuel',
        start_date:	"2025-02-01T12:00:00.000-03:00",
        end_date:	"2025-02-04T12:00:00.000-03:00",
        batches: batches
      }

      response = double('response', status: 200, body: batches.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/api/v1/events/1/ticket_batches').and_return(response)
      result = Batch.request_batches_by_event_id(event[:code])

      expect(result[0].name).to eq 'Entrada - VIP'
      expect(result[0].limit_tickets).to eq 50
      expect(result[0].start_date).to eq '2024-12-30'.to_date
      expect(result[0].value).to eq 40
      expect(result[0].end_date).to eq '2024-02-01'.to_date
      expect(result[1].name).to eq 'Entrada - Meia'
      expect(result[1].limit_tickets).to eq 20
      expect(result[1].start_date).to eq '2024-12-27'.to_date
      expect(result[1].value).to eq 20.00
      expect(result[1].end_date).to eq '2024-03-01'.to_date
    end

    it 'e deveria receber array vazio em caso de erro na requisição' do
      url = 'http://localhost:3000/api/v1/events/1/ticket_batches'
      response = double('faraday_response', body: "{}", status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(false)
      event = {
        code:	"1",
        name:	'Aprendedo a cozinhar',
        description:	'Aprenda a fritar um ovo',
        address:	'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
        banner_url:	'https://via.placeholder.com/300x200',
        logo_url: 'https://via.placeholder.com/100x100',
        participants_limit:	30,
        event_owner:	'Samuel',
        start_date:	"2025-02-01T12:00:00.000-03:00",
        end_date:	"2025-02-04T12:00:00.000-03:00",
        batches: []
      }

      result = Batch.request_batches_by_event_id(event[:code])

      expect(result.length).to eq 0
    end
  end

  context 'Esgotado?' do
    it 'verdadeiro quando o limite de ingressos tiver sido atingido' do
      batch = build(:batch, limit_tickets: 2)
      create_list(:ticket, 2, batch_id: batch.batch_id)

      expect(batch.sold_out?).to eq true
    end

    it 'falso quando o limite de ingressos não tiver sido atingido' do
      batch = build(:batch, limit_tickets: 10)
      create(:ticket, batch_id: batch.batch_id)

      expect(batch.sold_out?).to eq false
    end
  end

  context 'Verificação de limite com base apenas no id do lote' do
    it ' retorna verdadeiro se os ingressos estão esgotados para um certo lote' do
      batch = {
          code: "1",
          name: 'Entrada - VIP',
          tickets_limit: 2,
          start_date: '2024-12-30',
          ticket_price: 40.00,
          end_date: '2024-02-01',
          event_id: "1"
        }

      create_list(:ticket, 2, batch_id: batch[:code] )
      allow(EventsApiService).to receive(:get_batch_by_id).and_return(batch)

      expect(Batch.check_if_batch_is_sold_out(batch[:event_id], batch[:code])).to eq true
    end

    it 'retorna falso se os ingressos não estão esgotados para um certo lote' do
      batch = {
          code: "1",
          name: 'Entrada - VIP',
          tickets_limit: 2,
          start_date: '2024-12-30',
          ticket_price: 40.00,
          end_date: '2024-02-01',
          event_id: "1"
        }

      allow(EventsApiService).to receive(:get_batch_by_id).and_return(batch)

      expect(Batch.check_if_batch_is_sold_out(batch[:event_id], batch[:code])).to eq false
    end

    it 'retorna verdadeiro em caso de erro na requisição à API de Eventos' do
      batch = {
          code: '1',
          name: 'Entrada - VIP',
          tickets_limit: 2,
          start_date: '2024-12-30',
          ticket_price: 40.00,
          end_date: '2024-02-01',
          event_id: "1"
        }

      allow(EventsApiService).to receive(:get_batch_by_id).and_raise(Faraday::Error)

      expect(Batch.check_if_batch_is_sold_out(batch[:event_id], batch[:code])).to eq true
    end
  end
end
