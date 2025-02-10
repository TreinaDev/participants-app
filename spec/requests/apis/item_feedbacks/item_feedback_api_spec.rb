require 'rails_helper'

describe 'ITEM Feedback API' do
  context 'Retorna os feedback de um item de um evento' do
    it 'com sucesso' do
      user = create(:user, name: 'David', last_name: 'Martinez')
      user_two = create(:user, name: 'Gabriel', last_name: 'Tavares')
      create(:item_feedback, title: 'Título do feedback de item', comment: 'Comentário Padrão de item', mark: 4, event_id: '1', schedule_item_id: '1', public: true, user: user)
      create(:item_feedback, title: 'Uma porcaria', comment: 'Melhor você ganha', mark: 2, event_id: '1', schedule_item_id: '1', public: true, user: user_two)
      create(:item_feedback, title: 'Uma porcaria', comment: 'Melhor você ganha', mark: 2, event_id: '1', schedule_item_id: '2', public: true, user: user)

      get "/api/v1/schedule_items/1/item_feedbacks"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["item_feedbacks"][0]["id"]).to eq 1
      expect(json_response["item_feedbacks"][0]["schedule_item_id"]).to eq '1'
      expect(json_response["item_feedbacks"][0]["title"]).to eq 'Título do feedback de item'
      expect(json_response["item_feedbacks"][0]["comment"]).to eq 'Comentário Padrão de item'
      expect(json_response["item_feedbacks"][0]["mark"]).to eq 4
      expect(json_response["item_feedbacks"][0]["user"]).to eq 'David Martinez'
      expect(json_response["item_feedbacks"][1]["id"]).to eq 2
      expect(json_response["item_feedbacks"][1]["schedule_item_id"]).to eq '1'
      expect(json_response["item_feedbacks"][1]["title"]).to eq 'Uma porcaria'
      expect(json_response["item_feedbacks"][1]["comment"]).to eq 'Melhor você ganha'
      expect(json_response["item_feedbacks"][1]["mark"]).to eq 2
      expect(json_response["item_feedbacks"][1]["user"]).to eq 'Gabriel Tavares'
    end

    it 'e retorna 404 se não encontra feedbacks disponíveis' do
      allow(ItemFeedback).to receive(:where).and_return([])

      get "/api/v1/schedule_items/999/item_feedbacks"

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq 'Feedback items not found'
    end

    it 'E falha com um erro interno' do
      allow(ItemFeedback).to receive(:where).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/schedule_items/1/item_feedbacks"

      expect(response.status).to eq 500
    end
  end

  it 'e mostra respostas a um feedback' do
    user = create(:user, name: 'David', last_name: 'Martinez')
    item_feedback = create(:item_feedback, title: 'Título do feedback de item', comment: 'Comentário Padrão de item', mark: 4, event_id: '1', schedule_item_id: '1', public: true, user: user)
    post "/api/v1/item_feedbacks/#{item_feedback.id}/feedback_answers", params: {
        feedback_answer: {
            name: 'Nome do Participante Teste',
            email: 'email@teste.com',
            comment: 'Comentário Teste'
        }
      }

    get "/api/v1/schedule_items/1/item_feedbacks"

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(json_response["item_feedbacks"][0]["id"]).to eq 1
    expect(json_response["item_feedbacks"][0]["schedule_item_id"]).to eq '1'
    expect(json_response["item_feedbacks"][0]["title"]).to eq 'Título do feedback de item'
    expect(json_response["item_feedbacks"][0]["comment"]).to eq 'Comentário Padrão de item'
    expect(json_response["item_feedbacks"][0]["mark"]).to eq 4
    expect(json_response["item_feedbacks"][0]["user"]).to eq 'David Martinez'
    expect(json_response["item_feedbacks"][0]["feedback_answers"][0]["name"]).to eq 'Nome do Participante Teste'
    expect(json_response["item_feedbacks"][0]["feedback_answers"][0]["email"]).to eq 'email@teste.com'
    expect(json_response["item_feedbacks"][0]["feedback_answers"][0]["comment"]).to eq 'Comentário Teste'
  end
end
