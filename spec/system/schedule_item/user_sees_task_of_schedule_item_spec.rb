require 'rails_helper'

describe "Usuário acessa página de realização de uma tarefa", type: :system do
   it "e deve estar autenticado" do
    visit my_event_schedule_item_path(my_event_id: 1, id: 1)

    expect(current_path).to eq new_user_session_path
  end

  it "e deve ter um ingresso adquirido" do
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
    )

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(current_path).to eq root_path
    expect(page).to have_content "Você não participa deste evento"
  end

  it "e vê botão de finalizar tarefa" do
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
    curriculum = build(:curriculum)
    curriculum.tasks << build(:task)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    create(:ticket, event_id: event.event_id, batch_id:  target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum)

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(page).to have_button "Finalizar Tarefa"
    expect(page).not_to have_content "Tarefa finalizada"
  end

  it "e finaliza tarefa com sucesso" do
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
    message = {
      ok: true
    }
    batches = [ build(:batch) ]

    target_event_id = event.event_id
    target_batch_id =  batches[0].batch_id

    curriculum = build(:curriculum)
    curriculum.tasks << build(:task)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    create(:ticket, event_id: event.event_id, batch_id:  target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum).exactly(3)
    allow(Curriculum).to receive(:request_finalize_task).and_return(message)

    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')
    click_on "Finalizar Tarefa"

    expect(current_path).to eq my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')
    expect(page).to have_content "Tarefa finalizada com sucesso!"
  end

  it "e já realizou a tarefa" do
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
    curriculum = build(:curriculum)
    curriculum.tasks << build(:task, task_status: true)
    allow(Event).to receive(:request_event_by_id).and_return(event)
    create(:ticket, event_id: event.event_id, batch_id:  target_batch_id, user: user)
    allow(Batch).to receive(:request_batch_by_id).with(target_event_id, target_batch_id).and_return(batches[0])
    allow(Curriculum).to receive(:request_curriculum_by_schedule_item_and_user_code).and_return(curriculum).exactly(1)


    login_as user
    visit my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code],  locale: :'pt-BR')

    expect(page).not_to have_button "Finalizar Tarefa"
    expect(page).to have_content "Atividade Concluída!"
  end
end
