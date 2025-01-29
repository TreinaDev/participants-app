require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    context 'Título' do
      it { is_expected.to validate_presence_of(:title) }
    end

    context 'Conteúdo' do
      it { is_expected.to validate_presence_of(:content) }
    end
  end
end
