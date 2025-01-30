FactoryBot.define do
  factory :post do
    title { "Título" }
    content { "<strong>Conteúdo</strong>" }
    event_id { 1 }
    user
  end
end
