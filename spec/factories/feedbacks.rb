FactoryBot.define do
  factory :feedback do
    event_id { "1" }
    user
    title { "Título Padrão" }
    comment { "Comentário Padrão" }
    mark { 1 }
    public { false }
  end
end
