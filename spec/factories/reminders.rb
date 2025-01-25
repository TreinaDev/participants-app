FactoryBot.define do
  factory :reminder do
    user
    start_date { 1.month.from_now.to_date }
    event_id { 1 }
  end
end
