require 'rails_helper'

RSpec.describe FeedbackAnswer, type: :model do
  describe 'validations' do
    context 'Nome' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context 'E-mail' do
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'Comentário' do
      it { is_expected.to validate_presence_of(:comment) }
      subject { FactoryBot.build(:item_feedback) }
      it { is_expected.to validate_length_of(:comment).is_at_most(150) }
    end
  end
end
