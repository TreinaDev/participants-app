require 'rails_helper'

RSpec.describe "ScheduleItems", type: :request do
  describe 'Usuário acessa um item de agenda' do
    it 'e deve estar autenticado' do
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

      get(my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code]))

      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
      expect(response).to have_http_status(302)
    end

    it 'e vê os detalhes com sucesso' do
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
      create(:ticket, event_id: event.event_id, user: user)
      login_as user

      get(my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code]))

      expect(response).to have_http_status(200)
    end

    it 'e não vê os detalhes de um item de agenda que não possui ingresso' do
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
      login_as user

      get(my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code]))

      expect(response.status).to eq 302
      expect(flash[:alert]).to eq 'Você não participa deste evento'
    end

    it 'e vê conteudos e atividades do item da agenda com sucesso' do
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
      curriculum = Curriculum.new(contents: [],
       tasks: [
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
      )
      create(:ticket, event_id: event.event_id, user: user)
      allow(Curriculum).to receive(:request_curriculum_by_schedule_item_code).and_return(curriculum)

      login_as user
      get(my_event_schedule_item_path(my_event_id: event.event_id, id: schedules[0][:schedule_items][0][:code]))

      expect(response).to have_http_status(200)
      expect(response.body).to include("Exercício Rails")
      expect(response.body).to include("Seu primeiro exercício ruby")
      expect(response.body).to include("Obrigatória")
    end
  end
end
