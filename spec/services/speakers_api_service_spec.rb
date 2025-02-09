require 'rails_helper'

describe SpeakersApiService, type: :model do
  describe 'Usuário faz uma requisição de um curriculum' do
    it 'e recebe um currículo, por usuário, com sucesso' do
      curriculum = {
            "curriculum_contents": [
              {
                "code": "MH0IBQ8O",
                "title": "Ruby PDF",
                "description": "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E",
                "external_video_url": "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E",
                "files": [
                  {
                    "filename": "puts.png",
                    "file_download_url": "http://127.0.0.1:3003/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png"
                  }
                ]
              }
            ],
            "curriculum_tasks": [
              {
                "code": "FNRVUEUB",
                "title": "Exercício Rails",
                "description": "Seu primeiro exercício ruby",
                "certificate_requirement": "Obrigatória",
                "task_status": false,
                "attached_contents": [
                  {
                    "attached_content_code": "MH0IBQ8O"
                  }
                ]
              }
            ]
          }

      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234/participants/ASDFGHJK").and_return(response)
      results = SpeakersApiService.get_curriculum_by_user("ABCD1234", "ASDFGHJK")

      expect(results[:curriculum_contents][0][:code]).to eq 'MH0IBQ8O'
      expect(results[:curriculum_contents][0][:title]).to eq 'Ruby PDF'
      expect(results[:curriculum_contents][0][:description]).to eq "<strong>Descrição Ruby PDF</strong>"
      expect(results[:curriculum_contents][0][:external_video_url]).to eq "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E"
      expect(results[:curriculum_contents][0][:files][0][:filename]).to eq 'puts.png'
      expect(results[:curriculum_contents][0][:files][0][:file_download_url]).to eq 'http://127.0.0.1:3003/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png'

      expect(results[:curriculum_tasks][0][:code]).to eq 'FNRVUEUB'
      expect(results[:curriculum_tasks][0][:title]).to eq 'Exercício Rails'
      expect(results[:curriculum_tasks][0][:description]).to eq 'Seu primeiro exercício ruby'
      expect(results[:curriculum_tasks][0][:certificate_requirement]).to eq "Obrigatória"
      expect(results[:curriculum_tasks][0][:task_status]).to eq false
      expect(results[:curriculum_tasks][0][:attached_contents][0][:attached_content_code]).to eq 'MH0IBQ8O'
    end

    it 'e ocorre um erro na requisição' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234/participants/ASDFGHJK").and_raise(Faraday::ServerError)

      expect { SpeakersApiService.get_curriculum_by_user("ABCD1234", "ASDFGHJK") }.to raise_error(Faraday::ServerError)
    end
  end


  describe 'Usuário faz uma requisição de um palestrante' do
    it 'e recebe um palestrante com sucesso' do
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

      response = double('response', status: 200, body: speaker.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/speakers/silvio@sbt.com").and_return(response)
      result = SpeakersApiService.get_speaker("silvio@sbt.com")

      expect(result[:speaker][:first_name]).to eq 'Sílvio'
      expect(result[:speaker][:last_name]).to eq 'Santos'
      expect(result[:speaker][:profile_image_url]).to eq "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E"
      expect(result[:speaker][:role]).to eq "Apresentador"
      expect(result[:speaker][:profile_url]).to eq "https://globo.com"
    end

    it 'e ocorre um erro na requisição' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/speakers/silvio@sbt.com").and_raise(Faraday::ServerError)

      expect { SpeakersApiService.get_speaker("silvio@sbt.com") }.to raise_error(Faraday::ServerError)
    end
  end
end
