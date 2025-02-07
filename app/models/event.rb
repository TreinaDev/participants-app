class Event
  attr_accessor :name, :event_type, :banner, :logo, :event_id, :event_owner, :local_event, :description, :url_event, :limit_participants, :start_date, :end_date, :batches, :schedules, :announcements
  def initialize(event_id:, name:, event_type:, banner:, logo:, event_owner:, url_event:, local_event:, limit_participants:, description:, start_date:, end_date:, batches:, schedules:, announcements:)
    @event_id = event_id
    @name = name
    @event_type = event_type
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
    @announcements = build_announcement(announcements)
  end

  def rich_text_description
    ActionText::Content.new(@description)
  end

  def self.all
    response = EventsApiService.get_events
    events = response[:events]
    events.select { |event| DateTime.now.before?(event[:start_date].to_date) }.map { |event| build_event(event) }
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.search_events(query_string)
    response = EventsApiService.get_events(query_string)
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

  def self.request_events_posts(event_ids)
    posts_events = []
    event_ids.each do |id|
      posts_events << Event.request_event_by_id(id)
    end
    posts_events
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
      event_id: data[:code], name: data[:name], event_type: data[:event_type], banner: data[:banner_url], logo: data[:logo_url], event_owner: data[:event_owner],
      local_event: data[:address], limit_participants: data[:participants_limit],  url_event: data[:url_event], schedules: data[:schedules] || [],
      description: data[:description], start_date: data[:start_date].to_date, end_date: data[:end_date].to_date, batches: data[:ticket_batches] || [],
      announcements: data[:announcements] || []
    )
  end

  def build_batch(batches)
    batches.map { |data| Batch.new(batch_id: data[:code], name: data[:name], limit_tickets: data[:tickets_limit],
              start_date: data[:start_date].to_date, value: data[:ticket_price], end_date: data[:end_date].to_date,
              event_id: event_id) }
  end

  def build_announcement(announcements)
    announcements.map { |data| Announcement.new(announcement_id: data[:id], title: data[:title], description: data[:description], event_id: data[:event_id]) }
  end
end
