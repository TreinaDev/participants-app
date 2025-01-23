FactoryBot.define do
  factory :ticket do
    sequence(:id)
    confirmed_status { false }
    date_of_purchase { DateTime.now }
    payment_method { 1 }
    token { SecureRandom.alphanumeric(36) }
    user
    batch_id { 1 }
  end
end
