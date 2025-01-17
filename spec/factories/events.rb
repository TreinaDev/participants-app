FactoryBot.define do
  factory :event, class: Event do
    sequence(:event_id) { |n|  n }
    name { "Dev Week" }
    banner { 'http://localhost:3000/events/1/banner.jpg' }
    logo { 'http://localhost:3000/events/1/logo.jpg' }
    start_date { 2.days.from_now }
    end_date { 5.days.from_now }
    initialize_with { new(event_id: event_id, name:
                      name, banner: banner, logo: logo, start_date: start_date, end_date: end_date) }
  end
end
