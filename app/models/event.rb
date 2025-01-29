class Event
  attr_accessor :name, :banner, :logo, :event_id, :event_owner, :local_event, :description, :event_agendas, :url_event, :limit_participants, :start_date, :end_date, :batches
  def initialize(event_id:, name:, banner:, logo:, event_owner:, url_event:, local_event:, limit_participants:, description:, event_agendas:, start_date:, end_date:, batches:)
    @event_id = event_id
    @name = name
    @banner = banner
    @logo = logo
    @start_date = start_date
    @end_date = end_date
    @event_owner = event_owner
    @local_event = local_event
    @url_event = url_event
    @limit_participants = limit_participants
    @description = description
    @event_agendas = build_event_agenda(event_agendas)
    @batches = build_batch(batches)
  end

  def self.all
    events = EventsApiService.get_events
    events.select { |event| DateTime.now.before?(event[:start_date].to_date) }.map { |event| build_event(event) }
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.request_event_by_id(event_id)
    event_params = EventsApiService.get_event_by_id event_id
    build_event(event_params)
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

  def self.request_my_events(tickets)
    tickets.map { |ticket| Event.request_event_by_id(ticket.event_id) }
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
      event_id: data[:uuid], name: data[:name], banner: data[:banner_url], logo: data[:logo_url], event_owner: data[:event_owner],
      local_event: data[:address], limit_participants: data[:participants_limit],  url_event: data[:url_event],
      description: data[:description], event_agendas: data[:event_agendas] || [], start_date: data[:schedule][:start_date].to_date, end_date: data[:schedule][:end_date].to_date, batches: data[:batches] || []
    )
  end

  # event = {
  #   uuid:	"1",
  #   name:	'Aprendedo a cozinhar',
  #   description:	'Aprenda a fritar um ovo',
  #   address:	'Rua dos morcegos, 137, CEP: 40000000, Salvador, Bahia, Brasil',
  #   banner_url:	'https://via.placeholder.com/300x200',
  #   logo_url: 'https://via.placeholder.com/100x100',
  #   participants_limit:	30,
  #   event_owner:	'Samuel',
  #   schedule: {
  #     start_date:	"2025-02-01T12:00:00.000-03:00",
  #     end_date:	"2025-02-04T12:00:00.000-03:00"
  #   }
  # }

  def build_batch(batches)
    batches.map { |data| Batch.new(batch_id: data[:id], name: data[:name], limit_tickets: data[:limit_tickets],
              start_date: data[:start_date].to_date, value: data[:value], end_date: data[:end_date].to_date,
              event_id: data[:event_id]) }
  end
end
