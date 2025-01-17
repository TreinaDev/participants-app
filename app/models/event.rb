class Event
  attr_reader :name, :banner, :logo, :event_id, :start_date, :end_date
  def initialize(event_id:, name:, banner:, logo:, start_date:, end_date:)
    @event_id = event_id
    @name = name
    @banner = banner
    @logo = logo
    @start_date = start_date
    @end_date = end_date
  end

  def self.all
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    response = conn.get("https://localhost:3000/events")
    JSON.parse(response.body).filter_map { |event| Event.new(
                                            event_id: event["id"],
                                            name: event["name"],
                                            banner: event["banner"],
                                            logo: event["logo"],
                                            start_date: event["start_date"].to_date,
                                            end_date: event["end_date"].to_date) if DateTime.now.before?(event["start_date"].to_date)}
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.request_event_by_id(event_id)
    response = Faraday.get("http://localhost:3000/events/#{event_id}")

    event = JSON.parse(response.body)
    Event.new(event_id: event["id"], name: event["name"], banner: event["banner"],
              logo: event["logo"], start_date: event["start_date"], end_date: event["end_date"])
  end
end
