require 'rails_helper'

RSpec.describe Batch, type: :model do
  context 'Tipos de ingresso' do
    it "e retorna Tipos de ingresso" do
      travel_to(Time.zone.local(2024, 01, 01, 12, 04, 44))
      batches = [
        {
          id: 1,
          name: 'Entrada - VIP',
          limit_tickets: 50,
          start_date: '2024-12-30',
          value: 40.00,
          end_date: '2024-02-01',
          event_id: 1
        },
        {
          id: 2,
          name: 'Entrada - Meia',
          limit_tickets: 20,
          start_date: '2024-12-27',
          value: 20.00,
          end_date: '2024-03-01',
          event_id: 1
        }
      ]
      event = {
        id: 1,
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
        end_date: '2024-02-01',
        batches: batches
      }

      response = double('response', status: 200, body: batches.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with('http://localhost:3000/events/1/batches').and_return(response)
      result = Batch.request_batches_by_event_id(event[:id])

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
      url = 'http://localhost:3000/events/1/batches'
      response = double('faraday_response', body: "{}", status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(false)
      event = {
        id: 1,
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
        end_date: '2024-02-01',
        batches: []
      }

      result = Batch.request_batches_by_event_id(event[:id])

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
end
