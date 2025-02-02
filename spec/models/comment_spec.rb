require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    context 'Conteúdo' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_length_of(:content).is_at_most(200) }
    end
  end
end
