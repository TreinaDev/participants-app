FactoryBot.define do
  factory :item_feedback do
    event_id { "1" }
    user
    title { "Título Padrão" }
    comment { "Comentário Padrão" }
    mark { 1 }
    schedule_item_id { "1" }
    public { false }
  end
end
