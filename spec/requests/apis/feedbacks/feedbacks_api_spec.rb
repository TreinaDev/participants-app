require 'rails_helper'

describe 'Feedback API' do
  context 'Retorna os feedback de um evento' do
    it 'com sucesso' do
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      other_user = create(:user, name: 'David', last_name: 'Martinez')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
      create(:ticket, event_id: event.event_id, user: user)
      create(:ticket, event_id: event.event_id, user: other_user)
      allow(Event).to receive(:request_event_by_id).and_return(event)
      travel_to 6.days.from_now do
        login_as user
        create(:feedback, title: 'Título', comment: 'Comentário', mark: 4, event_id: event.event_id,
               user: user, public: false)
        login_as other_user
        create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
               user: other_user, public: true)

        get "/api/v1/events/#{event.event_id}/feedbacks"

        expect(response.status).to eq 200
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response["event_id"]).to eq '1'
        expect(json_response["feedbacks"][0]["id"]).to eq 1
        expect(json_response["feedbacks"][0]["title"]).to eq 'Título'
        expect(json_response["feedbacks"][0]["comment"]).to eq 'Comentário'
        expect(json_response["feedbacks"][0]["mark"]).to eq 4
        expect(json_response["feedbacks"][0]["user"]).to eq 'Gabriel Tavares'
        expect(json_response["feedbacks"][1]["id"]).to eq 2
        expect(json_response["feedbacks"][1]["title"]).to eq 'Título Padrão'
        expect(json_response["feedbacks"][1]["comment"]).to eq 'Comentário Padrão'
        expect(json_response["feedbacks"][1]["mark"]).to eq 3
        expect(json_response["feedbacks"][1]["user"]).to eq 'David Martinez'
      end
    end

    it 'e retorna 404 se não encontra evento' do
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      other_user = create(:user, name: 'David', last_name: 'Martinez')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
      travel_to 6.days.from_now do
        create(:ticket, event_id: event.event_id, user: user)
        create(:ticket, event_id: event.event_id, user: other_user)
        allow(Event).to receive(:request_event_by_id).and_return(nil)

        get "/api/v1/events/9999/feedbacks"

        expect(response.status).to eq 404
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq 'Event not found'
      end
    end

    it 'e retorna mensagem quando não existem feedbacks disponíveis' do
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
      allow(Event).to receive(:request_event_by_id).and_return(event)

      travel_to 6.days.from_now do
        get "/api/v1/events/#{event.event_id}/feedbacks"

        expect(response.status).to eq 404
        expect(response.content_type).to include 'application/json'
        json_response = JSON.parse(response.body)
        expect(json_response["event_id"]).to eq '1'
        expect(json_response["error"]).to eq 'There is no feedbacks to this event yet'
      end
    end

    it 'e retorna mensagem personalizado quando o evento ainda está em andamento' do
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
      allow(Event).to receive(:request_event_by_id).and_return(event)

      get "/api/v1/events/#{event.event_id}/feedbacks"

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["event_id"]).to eq '1'
      expect(json_response["error"]).to eq 'This event is still ongoing'
    end

    it 'E falha com um erro interno' do
      user = create(:user, name: 'Gabriel', last_name: 'Tavares')
      other_user = create(:user, name: 'David', last_name: 'Martinez')
      event = build(:event, event_id: '1', start_date: 5.days.ago, end_date: 5.days.from_now, name: 'DevWeek')
      create(:ticket, event_id: event.event_id, user: user)
      create(:ticket, event_id: event.event_id, user: other_user)
      allow(Event).to receive(:request_event_by_id).and_return(event)
      allow(Feedback).to receive(:where).and_raise(ActiveRecord::QueryCanceled)

      travel_to 6.days.from_now do
        login_as user
        create(:feedback, title: 'Título', comment: 'Comentário', mark: 4, event_id: event.event_id,
               user: user, public: false)
        login_as other_user
        create(:feedback, title: 'Título Padrão', comment: 'Comentário Padrão', mark: 3, event_id: event.event_id,
               user: other_user, public: true)

        get "/api/v1/events/#{event.event_id}/feedbacks"

        expect(response.status).to eq 500
      end
    end
  end
end
