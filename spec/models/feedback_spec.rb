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
end
