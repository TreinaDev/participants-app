require 'rails_helper'

describe 'User Details API' do
  context 'Posta informações dos detalhes de um usuário' do
    it 'com sucesso' do
      user = create(:user, name: 'Nome Teste', last_name: 'Sobrenome Teste', cpf: '42547083000', code: 'ABC123', email: 'teste@email.com', password: '123456')

      get "/api/v1/users/#{user.code}"

      expect(response).to have_http_status 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response['name']).to eq 'Nome Teste'
      expect(json_response['last_name']).to eq 'Sobrenome Teste'
      expect(json_response['cpf']).to eq '42547083000'
      expect(json_response['email']).to eq 'teste@email.com'
      expect(json_response.keys).not_to include 'password'
      expect(json_response.keys).not_to include 'id'
      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
    end

    it 'e não existe usuário com o código informado' do
      get "/api/v1/users/ZZZZZZ"

      expect(response).to have_http_status 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response['error']).to eq 'User not found'
    end

    it 'E falha com um erro interno' do
      allow(User).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/users/ZZZZZZ"

      expect(response.status).to eq 500
    end
  end
end
