class Event
  attr_reader :name, :banner, :logo, :event_id
  def initialize(event_id:, name:, banner:, logo:)
    @event_id = event_id
    @name = name
    @banner = banner
    @logo = logo
  end

  def self.all
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    response = conn.get("https://localhost:3000/events")
    JSON.parse(response.body).map { |event| Event.new(
                                            event_id: event["id"],
                                            name: event["name"],
                                            banner: event["banner"],
                                            logo: event["logo"]) }
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.request_event_by_id(event_id)
    response = Faraday.get("http://localhost:3000/events/#{event_id}")

    event = JSON.parse(response.body)
    Event.new(event_id: event["id"], name: event["name"], banner: event["banner"],
              logo: event["logo"])
  end
end
