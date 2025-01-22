FactoryBot.define do
  factory :batch do
    sequence(:batch_id)
    name { "Entrada -VIP" }
    limit_tickets { 50 }
    start_date { 1.day.from_now.to_date }
    value { 10.00 }
    end_date { 1.month.from_now.to_date }
    event_id { 1 }

    initialize_with do
      new(
        batch_id: batch_id,
        name: name,
        limit_tickets: limit_tickets,
        start_date: start_date,
        value: value,
        end_date: end_date,
        event_id: event_id
      )
    end
  end
end
