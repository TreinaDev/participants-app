require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe 'validations' do
    context 'Título' do
      it { is_expected.to validate_presence_of(:title) }
    end

    context 'Comentário' do
      it { is_expected.to validate_presence_of(:comment) }
      it { is_expected.to validate_length_of(:comment).is_at_most(150) }
    end

    context 'Nota' do
      it { is_expected.to validate_inclusion_of(:mark).in_range(1..5) }
    end
  end

  context '.user_indentification' do
    it 'Deve retornar Anônimo se public for falso' do
      feedback = create(:feedback, public: false)

      expect(feedback.user_identification).to eq "Anônimo"
    end

    it 'Deve retornar o nome completo do usuario se public for true' do
      user = create(:user, name: "André", last_name: "Kanamura")
      feedback = create(:feedback, user: user, public: true)

      expect(feedback.user_identification).to eq "André Kanamura"
    end
  end
end
