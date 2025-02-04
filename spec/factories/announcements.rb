FactoryBot.define do
  factory :announcement do
    sequence(:announcement_id)
    title { "Dev Week" }
    description { 'Aprenda em a ganhar 10 mil dólares em um mês' }
    event_id { "hjkds" }
    initialize_with do
      new(
        announcement_id: announcement_id,
        event_id: event_id,
        title: title,
        description: description,
      )
    end
  end
end
