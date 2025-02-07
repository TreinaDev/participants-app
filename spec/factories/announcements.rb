FactoryBot.define do
  factory :announcement do
    sequence(:announcement_id)
    title { "Dev Week" }
    description { 'Aprenda em a ganhar 10 mil dólares em um mês' }
    created_at { "2025-02-02T12:00:00.000-03:00" }

    initialize_with do
      new(
        announcement_id: announcement_id,
        created_at: created_at,
        title: title,
        description: description,
      )
    end
  end
end
