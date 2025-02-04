FactoryBot.define do
  factory :feedback do
    event_id { "1" }
    user
    coment { "MyString" }
    mark { 1 }
  end
end
