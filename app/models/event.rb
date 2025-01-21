class Event
  attr_accessor :name, :banner, :logo, :event_id, :event_owner, :local_event, :description, :event_agendas, :url_event, :limit_participants, :start_date, :end_date
  def initialize(event_id:, name:, banner:, logo:, event_owner:, url_event:, local_event:, limit_participants:, description:, event_agendas:, start_date:, end_date:)
    @event_id = event_id
    @name = name
    @banner = banner
    @logo = logo
    @start_date = start_date
    @end_date = end_date
    @event_owner = event_owner
    @url_event = url_event
    @local_event = local_event
    @limit_participants = limit_participants
    @description = description
    @event_agendas = build_event_agenda(event_agendas)
  end

  def self.all
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    response = conn.get("http://localhost:3000/api/events")
    events = JSON.parse(response.body, symbolize_names: true)
    events.select { |event| DateTime.now.before?(event[:start_date].to_date) }.map { |event| build_event(event) }
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.request_event_by_id(event_id)
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    response = conn.get("http://localhost:3000/api/events/#{event_id}")

    data = JSON.parse(response.body, symbolize_names: true)
    build_event(data)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    nil
  end

  def self.request_favorites(favorites)
    favorites_data = []
    favorites.each do |favorite|
      favorites_data << Event.request_event_by_id(favorite.event_id)
    end
    favorites_data
  end

  private

  def build_event_agenda(event_agendas)
    event_agendas.map { |event_agenda| EventAgenda.new(title: event_agenda[:title], description: event_agenda[:description],
                                                       email: event_agenda[:email], event_agenda_id: event_agenda[:event_agenda_id],
                                                       date: event_agenda[:date], instructor: event_agenda[:instructor],
                                                       start_time: event_agenda[:start_time], duration: event_agenda[:duration],
                                                       type: event_agenda[:agenda_type]) }
  end

  def self.build_event(data)
    Event.new(
      event_id: data[:id], name: data[:name], banner: data[:banner], logo: data[:logo], event_owner: data[:event_owner],
      url_event: data[:url_event], local_event: data[:local_event], limit_participants: data[:limit_participants],
       description: data[:description], event_agendas: data[:event_agendas] || [], start_date: data[:start_date].to_date, end_date: data[:end_date].to_date
    )
  end
end
