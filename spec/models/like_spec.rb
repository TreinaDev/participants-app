require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    context 'Usuário' do
      it { is_expected.to validate_presence_of(:user).with_message("é obrigatório(a)") }
    end

    context 'Postagem' do
      it { is_expected.to validate_presence_of(:post).with_message("é obrigatório(a)") }
    end
  end
end
