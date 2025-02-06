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

    batches = [ {
        batch_id: '1',
        name: 'Entrada - Meia',
        limit_tickets: 20,
        start_date: 5.days.ago.to_date,
        value: 20.00,
        end_date: 2.month.from_now.to_date,
        event_id: '1'
      }
    ]

    target_event_id = event.event_id
    target_batch_id =  batches[0][:batch_id]

    allow(Event).to receive(:request_event_by_id).and_return(event)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
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

    batches = [ {
        batch_id: '1',
        name: 'Entrada - Meia',
        limit_tickets: 20,
        start_date: 5.days.ago.to_date,
        value: 20.00,
        end_date: 2.month.from_now.to_date,
        event_id: event.event_id
      }
    ]
    target_event_id = event.event_id
    target_batch_id =  batches[0][:batch_id]

    allow(Event).to receive(:request_event_by_id).and_return(event)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit my_event_path(id: event.event_id, locale: :'pt-BR')
    within("#schedule_item_code_#{schedules[0][:schedule_items][0][:code]}") do
      click_on schedules[0][:schedule_items][0][:name]
    end

    expect(page).to have_content "Atividades"
    expect(page).to have_content "Conteúdos"
    expect(current_path).to eq schedule_item_path(schedules[0][:schedule_items][0][:code])
  end

  it "e consegue vê conteúdos e atividades daquele item da agenda" do
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

    batches = [ {
        batch_id: '1',
        name: 'Entrada - Meia',
        limit_tickets: 20,
        start_date: 5.days.ago.to_date,
        value: 20.00,
        end_date: 2.month.from_now.to_date,
        event_id: event.event_id
      }
    ]

    curriculum_api = {
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
          "attached_contents": [
            {
              "attached_content_code": "MH0IBQ8O"
            }
          ]
        }
      ]
    }

    curriculum = Curriculum.new(contents: curriculum_api[:curriculum_contents], tasks: curriculum_api[:curriculum_tasks])

    target_event_id = event.event_id
    target_batch_id =  batches[0][:batch_id]

    allow(Event).to receive(:request_event_by_id).and_return(event)
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_code).and_return(curriculum)
    ticket = create(:ticket, event_id: event.event_id, batch_id: '1', user: user)
    batches.map! { |batch| build(:batch, **batch) }
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])

    login_as user
    visit schedule_item_path(schedules[0][:schedule_items][0][:code])

    expect(page).to have_content "Atividades"
    expect(page).to have_content "Conteúdos"
    expect(page).to have_content 'Ruby PDF'
    expect(page).to have_content "\u003Cstrong\u003EDescrição Ruby PDF\u003C/strong\u003E"
    expect(page).to have_content "\u003Ciframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/idaXF2Er4TU' frameborder='0' allowfullscreen\u003E\u003C/iframe\u003E"
    expect(page).to have_content "Exercício Rails"
    expect(page).to have_content 'Seu primeiro exercício ruby'
  end
end
