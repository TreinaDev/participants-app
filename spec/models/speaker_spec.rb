require 'rails_helper'

RSpec.describe Speaker, type: :model do
  context 'detalhes de um palestrante' do
    it "com sucesso" do
      speaker = {
        "speaker":
          {
            "first_name": "Sílvio",
            "last_name": "Santos",
            "photo_url": "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E",
            "occupation": "Apresentador",
            "profile_link": "https://globo.com"
          }
        }

      schedule_item_id = "ABCD1234"
      response = double('response', status: 200, body: speaker.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/schedule_items/#{schedule_item_id}").and_return(response)
      result = Speaker.request_speaker_by_schedule_item_id(schedule_item_id)

      expect(result.first_name).to eq 'Sílvio'
      expect(result.last_name).to eq 'Santos'
      expect(result.photo_url).to eq "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E"
      expect(result.occupation).to eq "Apresentador"
      expect(result.profile_link).to eq "https://globo.com"
    end

    it 'e deve retornar nulo em caso de erro na requisição' do
      schedule_item_id = "ABCD1234"
      url = "http://localhost:3003/api/v1/schedule_items/#{schedule_item_id}"
      response = double('faraday_response', body: "{}", status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(false)
      allow(Rails.logger).to receive(:error)
      result = Speaker.request_speaker_by_schedule_item_id(schedule_item_id)

      expect(result).to eq nil
      expect(Rails.logger).to have_received(:error)
    end
  end
end
