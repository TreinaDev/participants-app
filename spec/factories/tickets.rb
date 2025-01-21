FactoryBot.define do
  factory :ticket do
    status { 1 }
    date_of_purchase { "2025-01-21 17:19:13" }
    payment_method { 1 }
    token { "MyString" }
    user { nil }
    batch_id { 1 }
  end
end
