FactoryBot.define do
  factory :event do
    event_id { 1 }
    name { "Dev Week" }
    banner { 'http://localhost:3000/events/1/banner.jpg' }
    logo { 'http://localhost:3000/events/1/logo.jpg' }
    initialize_with do
      new(
        event_id: event_id,
        name: name,
        banner: banner,
        logo: logo
      )
    end
  end
end
