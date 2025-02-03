FactoryBot.define do
  factory :comment do
    user
    post
    content { "Comentário" }
  end
end
