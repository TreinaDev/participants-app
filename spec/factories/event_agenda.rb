FactoryBot.define do
  factory :event_agenda do
      event_agenda_id { 1 }
      date { '15/08/2025' }
      title { 'Aprendendo a fritar salgados' }
      description { 'lorem ipsum' }
      instructor { 'Jacaré' }
      email { 'jacare@email.com' }
      start_time { '11:00' }
      duration { 120 }
      type { 'Work-shop' }

    initialize_with do
      new(
        event_agenda_id: event_agenda_id,
        date: date,
        title: title,
        description: description,
        instructor: instructor,
        email: email,
        start_time: start_time,
        duration: duration,
        type: type
      )
    end
  end
end
