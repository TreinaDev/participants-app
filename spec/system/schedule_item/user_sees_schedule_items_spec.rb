require 'rails_helper'

describe "Usuário vê itens de agenda", type: :system do
  it "com sucesso" do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          },
          {
            name:	"Segunda Palestra",
            start_time:	"2025-02-14T10:00:00.000-03:00",
            end_time:	"2025-02-14T11:00:00.000-03:00",
            code: "6XD2I9RA"
          }
        ]
      },
      {
        date: 	"2025-02-15",
        schedule_items: [
          {
            name:	"Apresentação",
            start_time:	"2025-02-15T09:00:00.000-03:00",
            end_time:	"2025-02-15T10:00:00.000-03:00",
            code: "8XDGREWQ"
          }
        ]
      },
      {
        date: 	"2025-02-16",
        schedule_items: []
      }

    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]

    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    allow(Event).to receive(:request_event_by_id).and_return(event)
    create(:ticket, event_id: event.event_id, batch_id:  target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_path(id: event.event_id, locale: :'pt-BR')

    expect(page).to have_content "14/02/2025"
    expect(page).to have_content "Palestra"
    expect(page).to have_content "Início: 09:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "Segunda Palestra"
    expect(page).to have_content "Início: 10:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "15/02/2025"
    expect(page).to have_content "Apresentação"
    expect(page).to have_content "Início: 09:00"
    expect(page).to have_content "Duração: 60min"
    expect(page).to have_content "16/02/2025"
    expect(page).to have_content 'Ainda não existe programação cadastrada para esse dia'
  end

  it 'e consegue ver as tarefas e conteúdos depois de clicar no item da agenda' do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          },
          {
            name:	"Segunda Palestra",
            start_time:	"2025-02-14T10:00:00.000-03:00",
            end_time:	"2025-02-14T11:00:00.000-03:00",
            code: "6XD2I9RA"
          }
        ]
      }
    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]
    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    allow(Event).to receive(:request_event_by_id).and_return(event)
    create(:ticket, event_id: event.event_id, batch_id: target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_path(id: event.event_id, locale: :'pt-BR')
    within("#schedule_item_code_#{schedules[0][:schedule_items][0][:code]}") do
      click_on schedules[0][:schedule_items][0][:name]
    end

    expect(page).to have_content "Atividades"
    expect(page).to have_content "Conteúdos"
    expect(current_path).to eq my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')
    expect(current_path).not_to eq my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][1][:code],  locale: :'pt-BR')
  end

  it "e consegue ver conteúdos e atividades daquele item da agenda" do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          }
        ]
      }
    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]
    curriculum = Curriculum.new(
      contents: [
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
      tasks_available: true,
      certificate_url: "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf",
      tasks: [
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
    )

    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum)
    create(:ticket, event_id: event.event_id, batch_id: batches[0].batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(page).to have_content "Atividades"
    expect(page).to have_content "Conteúdos"
    expect(page).to have_content 'Ruby PDF'
    expect(page).to have_content "Descrição Ruby PDF"
    expect(page).to have_content "Exercício Rails"
    expect(page).to have_content 'Seu primeiro exercício ruby'
    expect(page).to have_content 'Necessário para certificado'
    expect(current_path).to eq my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')
  end

  it "não consegue acessar a agenda sem estar autenticado" do
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          }
        ]
      }
    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]

    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Para continuar, faça login ou registre-se."
  end

  it 'e recebe aviso caso atividades não estejam disponíveis' do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          }
        ]
      }
    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]
    curriculum = Curriculum.new(
      contents: [
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
      tasks_available: false,
      certificate_url: "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf",
      tasks: [
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
    )

    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum)
    create(:ticket, event_id: event.event_id, batch_id: batches[0].batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(page).to have_content "Atividades ainda indisponíveis"
    expect(page).to have_content 'Ruby PDF'
    expect(page).to have_content "Descrição Ruby PDF"
    expect(page).not_to have_content "Exercício Rails"
    expect(page).not_to have_content 'Seu primeiro exercício ruby'
    expect(page).not_to have_content 'Necessário para certificado'
    expect(current_path).to eq my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')
  end

  it "e recebe mensagem de aviso caso não exista atividades e/ou conteúdos para o item da agenda" do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          }
        ]
      }
    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]
    curriculum = Curriculum.new(contents: [], tasks: [], tasks_available: true, certificate_url: "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf")

    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum)
    create(:ticket, event_id: event.event_id, batch_id: batches[0].batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(page).to have_content "Nenhum conteúdo disponível"
    expect(page).to have_content "Nenhuma atividade disponível"
    expect(current_path).to eq my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')
  end

  it "tem acesso ao certificado caso tenha cumprido os requisitos" do
    user = create(:user)
    schedules = [
      {
        date: 	"2025-02-14",
        schedule_items: [
          {
            name:	"Palestra",
            start_time:	"2025-02-14T09:00:00.000-03:00",
            end_time:	"2025-02-14T10:00:00.000-03:00",
            code: "GOEX84DP"
          }
        ]
      }
    ]
    event = build(:event,
      schedules: schedules
    )

    batches = [ build(:batch) ]
    curriculum = Curriculum.new(contents: [], tasks: [], tasks_available: true, certificate_url: "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf")

    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum)
    create(:ticket, event_id: event.event_id, batch_id: batches[0].batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(page).to have_link "Meu certificado", href: "http://localhost:3000/certificates/PIMZBVXM04DWVNVWI90H.pdf"
  end
end
