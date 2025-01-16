class Event
  attr_accessor :name, :banner, :logo, :event_id, :event_owner, :local_event, :description, :event_agendas, :url_event, :limit_participants
  def initialize(event_id:, name:, banner:, logo:, event_owner:, url_event:, local_event:, limit_participants:, description:, event_agendas:)
    @event_id = event_id
    @name = name
    @banner = banner
    @logo = logo
    @event_owner = event_owner
    @url_event = url_event
    @local_event = local_event
    @limit_participants = limit_participants
    @description = description
    @event_agendas = event_agendas.map { |event_agenda| EventAgenda.new(title: event_agenda[:title], description: event_agenda[:description], email: event_agenda[:email], event_agenda_id: event_agenda[:event_agenda_id], date: event_agenda[:date], instructor: event_agenda[:instructor], start_time: event_agenda[:start_time], duration: event_agenda[:duration], type: event_agenda[:type]) }
  end

  def self.request_event_by_id(event_id)
    response = Faraday.get("http://localhost:3000/events/#{event_id}")
    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      Event.new(
        event_id: data[:event_id],
        name: data[:name],
        banner: data[:banner],
        logo: data[:logo],
        event_owner: data[:event_owner],
        url_event: data[:url_event],
        local_event: data[:local_event],
        limit_participants: data[:limit_participants],
        description: data[:description],
        event_agendas: data[:event_agendas]
      )
    end
  end
end
