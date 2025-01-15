require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'Nome de Usuário' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context 'Sobrenome de Usuário' do
      it { is_expected.to validate_presence_of(:last_name) }
    end

    context 'CPF de Usuário' do
      it { is_expected.to validate_presence_of(:cpf) }
    end
  end
end
