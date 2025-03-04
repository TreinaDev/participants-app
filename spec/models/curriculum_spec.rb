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

      user_code = "ASDFGHJK"
      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234/participants/#{user_code}").and_return(response)
      results = Curriculum.request_curriculum_by_schedule_item_and_user_code("ABCD1234", user_code)

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

      user_code = "ASDFGHJK"
      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234/participants/#{user_code}").and_return(response)
      results = Curriculum.request_curriculum_by_schedule_item_and_user_code("ABCD1234", user_code)

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
          "certificate_url": "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf",
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
      }

      user_code = "ASDFGHJK"
      response = double('response', status: 200, body: curriculum.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234/participants/#{user_code}").and_return(response)
      results = Curriculum.request_curriculum_by_schedule_item_and_user_code("ABCD1234", user_code)

      expect(results.tasks_available).to eq true
      expect(results.certificate_url).to eq "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf"
      expect(results.contents[0].code).to eq 'MH0IBQ8O'
      expect(results.contents[0].title).to eq 'Ruby PDF'
      expect(results.contents[0].description).to eq "<strong>Descrição Ruby PDF</strong>"
      expect(results.contents[0].external_video_url).to eq "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E"
      expect(results.contents[0].files[0][:filename]).to eq 'puts.png'
      expect(results.contents[0].files[0][:file_download_url]).to eq 'http://127.0.0.1:3003/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--97207adb5d87fac1fb977c3ae5b3896f2de5fe1a/puts.png'

      expect(results.tasks[0].code).to eq 'FNRVUEUB'
      expect(results.tasks[0].title).to eq 'Exercício Rails'
      expect(results.tasks[0].description).to eq 'Seu primeiro exercício ruby'
      expect(results.tasks[0].task_status).to eq false
      expect(results.tasks[0].certificate_requirement).to eq "Obrigatória"
      expect(results.tasks[0].attached_contents[0][:attached_content_code]).to eq 'MH0IBQ8O'
    end
  end

  it 'e deveria retornar um currículo sem atividades e sem conteudos em caso de erro na requisição' do
    user_code = "ASDFGHJK"
    response = double('faraday_response', body: "{}", status: 500)
    allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://localhost:3003/api/v1/curriculums/ABCD1234/participants/#{user_code}").and_return(response)
    result = Curriculum.request_curriculum_by_schedule_item_and_user_code("ABCD1234", user_code)

    expect(result.contents).to eq []
    expect(result.tasks).to eq []
  end

  describe 'e completa uma tarefa' do
    it 'com sucesso' do
      message = {
       "message": "OK"
      }
      user_code = "user123"
      task_code = "task456"
      response = double('response', status: 200, body: message.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:post).with("http://localhost:3003/api/v1/participant_tasks", { participant_code: user_code, task_code: task_code }.to_json).and_return(response)

      result = Curriculum.request_finalize_task(user_code, task_code)

      expect(result[:ok]).to eq true
    end

    it 'e retorna um Curriculum vazio em caso de falha' do
      user_code = "user123"
      task_code = "task456"

      allow_any_instance_of(Faraday::Connection).to receive(:post)
        .with("http://localhost:3003/api/v1/participant_tasks", { participant_code: user_code, task_code: task_code }.to_json)
        .and_raise(Faraday::ConnectionFailed.new("Connection failed"))
      result = Curriculum.request_finalize_task(user_code, task_code)

      expect(result[:ok]).to eq false
    end
  end
end
