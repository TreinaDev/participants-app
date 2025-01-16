FactoryBot.define do
  factory :event do
    event_id { 1 }
    name { "Dev Week" }
    banner { 'http://localhost:3000/events/1/banner.jpg' }
    logo { 'http://localhost:3000/events/1/logo.jpg' }
    url_event { 'https://ecvitoria.com.br/public/Inicio/' }
    local_event { 'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil' }
    limit_participants { 30 }
    description { 'Aprenda a fritar um ovo' }
    event_owner { 'Samuel' }
    event_agendas { [] }

    initialize_with do
      new(
        event_id: event_id,
        name: name,
        banner: banner,
        logo: logo,
        url_event: url_event,
        local_event: local_event,
        limit_participants: limit_participants,
        description: description,
        event_owner: event_owner,
        event_agendas: event_agendas
      )
    end
  end
end
