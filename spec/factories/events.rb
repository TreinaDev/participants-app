FactoryBot.define do
  factory :event do
    sequence(:event_id)
    name { "Dev Week" }
    banner { 'http://localhost:3000/events/1/banner.jpg' }
    logo { 'http://localhost:3000/events/1/logo.jpg' }
    start_date { 2.days.from_now }
    end_date { 5.days.from_now }
    url_event { 'https://ecvitoria.com.br/public/Inicio/' }
    local_event { 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil' }
    limit_participants { 30 }
    description { 'Aprenda a fritar um ovo' }
    event_owner { 'Samuel' }
    event_agendas { [] }
    batches { [] }

    initialize_with do
      new(
        event_id: event_id,
        name: name,
        banner: banner,
        logo: logo,
        start_date: start_date,
        end_date: end_date,
        url_event: url_event,
        local_event: local_event,
        limit_participants: limit_participants,
        description: description,
        event_owner: event_owner,
        event_agendas: event_agendas,
        batches: batches
      )
    end
  end
end
