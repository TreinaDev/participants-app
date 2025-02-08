require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  context "conteúdo de um currículo" do
    it "e retorna currículo" do
      curriculum = {
        "curriculum": {
          "curriculum_contents": [],
          "tasks_available": true,
          "curriculum_tasks": []
        }
      }

      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234").and_return(response)
      results = Curriculum.request_curriculum_by_schedule_item_code("ABCD1234")

      expect(results.contents).to eq []
      expect(results.tasks).to eq []
      expect(results.tasks_available).to eq true
    end

    it "e retorna com conteudo" do
      curriculum = {
        "curriculum": {
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
          "curriculum_tasks": []
        }
      }

      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234").and_return(response)
      results = Curriculum.request_curriculum_by_schedule_item_code("ABCD1234")

      expect(results.contents[0].code).to eq 'MH0IBQ8O'
      expect(results.contents[0].title).to eq 'Ruby PDF'
      expect(results.contents[0].description).to eq "<strong>Descrição Ruby PDF</strong>"
      expect(results.contents[0].external_video_url).to eq "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E"
      expect(results.contents[0].files[0][:filename]).to eq 'puts.png'
      expect(results.contents[0].files[0][:file_download_url]).to eq 'http://127.0.0.1:3003/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png'
    end

    it 'e retornar curriculum com tarefas' do
      curriculum = {
        "curriculum": {
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
          "tasks_available": true,
          "curriculum_tasks": [
            {
              "code": "FNRVUEUB",
              "title": "Exercício Rails",
              "description": "Seu primeiro exercício ruby",
              "certificate_requirement": "Obrigatória",
              "attached_contents": [
                {
                  "attached_content_code": "MH0IBQ8O"
                }
              ]
            }
          ]
        }
      }

      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234").and_return(response)
      results = Curriculum.request_curriculum_by_schedule_item_code("ABCD1234")

      expect(results.tasks_available).to eq true

      expect(results.contents[0].code).to eq 'MH0IBQ8O'
      expect(results.contents[0].title).to eq 'Ruby PDF'
      expect(results.contents[0].description).to eq "<strong>Descrição Ruby PDF</strong>"
      expect(results.contents[0].external_video_url).to eq "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E"
      expect(results.contents[0].files[0][:filename]).to eq 'puts.png'
      expect(results.contents[0].files[0][:file_download_url]).to eq 'http://127.0.0.1:3003/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png'

      expect(results.tasks[0].code).to eq 'FNRVUEUB'
      expect(results.tasks[0].title).to eq 'Exercício Rails'
      expect(results.tasks[0].description).to eq 'Seu primeiro exercício ruby'
      expect(results.tasks[0].certificate_requirement).to eq "Obrigatória"
      expect(results.tasks[0].attached_contents[0][:attached_content_code]).to eq 'MH0IBQ8O'
    end
  end

  it 'e deveria retornar um currículo sem atividades e sem conteudos em caso de erro na requisição' do
    response = double('faraday_response', body: "{}", status: 500)
    allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234").and_return(response)
    result = Curriculum.request_curriculum_by_schedule_item_code("ABCD1234")

    expect(result.contents).to eq []
    expect(result.tasks).to eq []
  end
end
