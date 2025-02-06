FactoryBot.define do
  factory :schedule_item do
    name { "Nome Teste" }
    start_time { 2.days.from_now }
    end_time { 5.days.from_now }
    code { "ABCD1423" }
  end
end
