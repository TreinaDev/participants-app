require 'rails_helper'

RSpec.describe Announcement, type: :model do
  context 'validations' do
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:title) }
  end
end
