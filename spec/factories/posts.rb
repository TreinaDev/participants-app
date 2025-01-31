FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Título#{n}" }
    content { "<strong>Conteúdo</strong>" }
    event_id { 1 }
    sequence(:created_at) { |n| n.days.ago }
    user
  end
end
