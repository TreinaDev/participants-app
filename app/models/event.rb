class Event
  attr_accessor :name, :banner, :logo, :event_id, :event_owner, :local_event, :description, :url_event, :limit_participants, :start_date, :end_date, :batches, :schedules
  def initialize(event_id:, name:, banner:, logo:, event_owner:, url_event:, local_event:, limit_participants:, description:, start_date:, end_date:, batches:, schedules:)
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
    @schedules = build_schedules(schedules)
    @batches = build_batch(batches)
  end

  def self.all
    response = EventsApiService.get_events
    events = response[:events]
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
      puts favorites_data
    end
    favorites_data
  end

  def self.request_my_events(tickets)
    tickets.map { |ticket| Event.request_event_by_id(ticket.event_id) }
  end

  private

  def build_schedules(schedules)
    schedules.map { |schedule| Schedule.new(date: schedule[:date], schedule_items: schedule[:schedule_items]) }
  end

  def self.build_event(data)
    Event.new(
      event_id: data[:code], name: data[:name], banner: data[:banner_url], logo: data[:logo_url], event_owner: data[:event_owner],
      local_event: data[:address], limit_participants: data[:participants_limit],  url_event: data[:url_event], schedules: data[:schedules] || [],
      description: data[:description], start_date: data[:start_date].to_date, end_date: data[:end_date].to_date, batches: data[:ticket_batches] || []
    )
  end

  def build_batch(batches)
    batches.map { |data| Batch.new(batch_id: data[:code], name: data[:name], limit_tickets: data[:tickets_limit],
              start_date: data[:start_date].to_date, value: data[:ticket_price], end_date: data[:end_date].to_date,
              event_id: event_id) }
  end
end
