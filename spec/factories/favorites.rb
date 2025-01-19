FactoryBot.define do
  factory :favorite do
    user
    sequence(:event_id)
  end
end
