require 'rails_helper'

describe 'Feedback Answer API' do
  context 'Posta informações da resposta do feedback de um item do evento' do
    it 'com sucesso' do
      schedules = [
        {
          date: 	5.day.ago,
          schedule_items: [
            {
              name:	"Palestra",
              start_time:	5.day.ago.beginning_of_day + 9.hours,
              end_time:	5.day.ago.beginning_of_day + 10.hours,
              code: '1'
            }
          ]
        }
      ]
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
      schedule_item = event.schedules[0].schedule_items[0]
      create(:ticket, event_id: event.event_id, user: user)
      allow(Event).to receive(:request_event_by_id).and_return(event)
      login_as user
      item_feedback = create(:item_feedback, title: 'Título do feedback de item', comment: 'Comentário Padrão de item', mark: 4, event_id: event.event_id,
                                             user: user, schedule_item_id: schedule_item.schedule_item_id, public: true)

      post "/api/v1/item_feedbacks/#{item_feedback.id}/feedback_answers", params: {
            feedback_answers: {
            name: 'Nome do Participante Teste',
            email: 'email@teste.com',
            comment: 'Comentário Teste'
          }
        }

      expect(response).to have_http_status 201
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq 'Nome do Participante Teste'
      expect(json_response['email']).to eq 'email@teste.com'
      expect(json_response['comment']).to eq 'Comentário Teste'
      expect(json_response['item_feedback_id']).to eq item_feedback.id
    end

    it 'e retorna erro quando a criação não é válida' do
      schedules = [
        {
          date: 	5.day.ago,
          schedule_items: [
            {
              name:	"Palestra",
              start_time:	5.day.ago.beginning_of_day + 9.hours,
              end_time:	5.day.ago.beginning_of_day + 10.hours,
              code: '1'
            }
          ]
        }
      ]
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
      schedule_item = event.schedules[0].schedule_items[0]
      create(:ticket, event_id: event.event_id, user: user)
      allow(Event).to receive(:request_event_by_id).and_return(event)

      login_as user
      item_feedback = create(:item_feedback, title: 'Título do feedback de item', comment: 'Comentário Padrão de item', mark: 4, event_id: event.event_id,
              user: user, schedule_item_id: schedule_item.schedule_item_id, public: true)

      post "/api/v1/item_feedbacks/#{item_feedback.id}/feedback_answers", params: {
            feedback_answers: {
            name: '',
            email: '',
            comment: ''
          }
        }

      expect(response).to have_http_status 406
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to match_array [ "Name can't be blank", "Email can't be blank", "Comment can't be blank" ]
    end

    it 'e retorna erro quando não acha o feedback do item do evento' do
      schedules = [
        {
          date: 	5.day.ago,
          schedule_items: [
            {
              name:	"Palestra",
              start_time:	5.day.ago.beginning_of_day + 9.hours,
              end_time:	5.day.ago.beginning_of_day + 10.hours,
              code: '1'
            }
          ]
        }
      ]
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
      create(:ticket, event_id: event.event_id, user: user)
      allow(Event).to receive(:request_event_by_id).and_return(event)
      item_feedback_id = 9999
      login_as user

      post "/api/v1/item_feedbacks/#{item_feedback_id}/feedback_answers", params: {
            feedback_answers: {
            name: 'Nome do Participante Teste',
            email: 'email@teste.com',
            comment: 'Comentário Teste'
          }
        }

      expect(response).to have_http_status 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Item feedback not found'
    end

    it 'e retorna erro quando falha o servidor' do
      schedules = [
        {
          date: 	5.day.ago,
          schedule_items: [
            {
              name:	"Palestra",
              start_time:	5.day.ago.beginning_of_day + 9.hours,
              end_time:	5.day.ago.beginning_of_day + 10.hours,
              code: '1'
            }
          ]
        }
      ]
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 2.days.ago, name: 'DevWeek', schedules: schedules)
      schedule_item = event.schedules[0].schedule_items[0]
      create(:ticket, event_id: event.event_id, user: user)
      allow(Event).to receive(:request_event_by_id).and_return(event)
      login_as user
      item_feedback = create(:item_feedback, title: 'Título do feedback de item', comment: 'Comentário Padrão de item', mark: 4, event_id: event.event_id,
                                             user: user, schedule_item_id: schedule_item.schedule_item_id, public: true)
      allow(FeedbackAnswer).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      post "/api/v1/item_feedbacks/#{item_feedback.id}/feedback_answers", params: {
        feedback_answers: {
        name: 'Nome do Participante Teste',
        email: 'email@teste.com',
        comment: 'Comentário Teste'
      }
    }

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'An unexpected error occurred'
    end
  end
end
