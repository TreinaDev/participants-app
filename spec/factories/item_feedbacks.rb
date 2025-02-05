FactoryBot.define do
  factory :item_feedback do
    title { "MyString" }
    comment { "MyString" }
    answer { "MyString" }
    mark { 1 }
    public { false }
    event_id { "MyString" }
    user { nil }
    schedule_item_id { "MyString" }
  end
end
