FactoryBot.define do
  factory :feedback do
    event_id { "MyString" }
    user { nil }
    coment { "MyString" }
    mark { 1 }
  end
end
