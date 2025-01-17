FactoryBot.define do
  factory :event, class: Event do
    sequence(:event_id) { |n|  n }
    name { "Dev Week" }
    banner { 'http://localhost:3000/events/1/banner.jpg' }
    logo { 'http://localhost:3000/events/1/logo.jpg' }
    initialize_with { new(event_id: event_id, name:
                      name, banner: banner, logo: logo) }
  end
end
