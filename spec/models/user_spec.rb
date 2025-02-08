require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#cpf_valid' do
    it 'não gera se cpf válido' do
      user = build(:user, cpf: CPF.generate)

      result = user.valid?

      expect(result).to eq true
    end

    it 'gera erro se cpf inválido' do
      user = build(:user, cpf: 'abc')

      result = user.valid?

      expect(result).to eq false
    end

    it 'e mostra mensagem de erro' do
      user = build(:user, cpf: 'abc')

      user.valid?

      expect(user.errors.full_messages).to include 'CPF inválido'
    end
  end

  describe '#participates_in_event?' do
    it 'retorna true se participa do evento' do
      event = build(:event, event_id: 1)
      ticket = create(:ticket, event_id: event.event_id)
      user = ticket.user

      result = user.participates_in_event?(event.event_id)

      expect(result).to eq true
    end

    it 'retorna false se não participa do evento' do
      event = build(:event, event_id: 1)
      user = create(:user)

      result = user.participates_in_event?(event.event_id)

      expect(result).to eq false
    end
  end

  describe '#full_name' do
    it 'retorna o nome completo do usuário' do
      user = create(:user, name: 'teste', last_name: 'não teste')

      result = user.full_name

      expect(result).to eq 'teste não teste'
    end
  end

  describe 'validations' do
    context 'Nome de Usuário' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context 'Sobrenome de Usuário' do
      it { is_expected.to validate_presence_of(:last_name) }
    end

    context 'CPF de Usuário' do
      it { is_expected.to validate_presence_of(:cpf) }
      subject { FactoryBot.build(:user) }
      it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }
    end
  end

  describe 'creation' do
    it 'code é gerado na criação do registro' do
      user = User.new(email: 'master@email.com', password: 'asdfqw', name: 'Master', last_name: 'of Puppets', cpf: CPF.generate)

      expect(user.code).to be_nil

      user.save

      expect(user.code).to be_present
    end

    it 'e não muda com atualização do registro' do
      user = User.create(email: 'master@email.com', password: 'asdfqw', name: 'Master', last_name: 'of Puppets', cpf: CPF.generate)
      code = user.code
      user.name = "MASTER"
      user.save

      expect(user.code).to eq code
    end
  end
end
