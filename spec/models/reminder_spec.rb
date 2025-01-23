require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe 'validations' do
    context 'event_id' do
      it { is_expected.to validate_presence_of(:event_id) }
      it { is_expected.to validate_numericality_of(:event_id) }
    end

    context 'user' do
      it { is_expected.to validate_presence_of(:user) }
    end
  end
end
