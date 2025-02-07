require 'rails_helper'

RSpec.describe Speaker, type: :model do
  context 'detalhes de um palestrante' do
    it "com sucesso" do
      speaker = {
        "speaker":
          {
            "first_name": "Sílvio",
            "last_name": "Santos",
            "profile_image_url": "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E",
            "role": "Apresentador",
            "profile_url": "https://globo.com"
          }
        }

      email = "silvio@sbt.com"
      response = double('response', status: 200, body: speaker.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/speakers/#{email}").and_return(response)
      result = Speaker.request_speakers_by_email([ email ])

      expect(result[0].first_name).to eq 'Sílvio'
      expect(result[0].last_name).to eq 'Santos'
      expect(result[0].profile_image_url).to eq "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E"
      expect(result[0].role).to eq "Apresentador"
      expect(result[0].profile_url).to eq "https://globo.com"
    end

    it 'e deve retornar nulo em caso de erro na requisição' do
      email = "silvio@sbt.com"
      url = "http://localhost:3003/api/v1/speakers/#{email}"
      response = double('faraday_response', body: "{}", status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(false)
      allow(Rails.logger).to receive(:error)
      result = Speaker.request_speakers_by_email([ email ])

      expect(result).to eq []
      expect(Rails.logger).to have_received(:error)
    end
  end
end
