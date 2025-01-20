class EventsApiService
  def self.get_events
    self.request('http://localhost:3000/events', :get)
  end

  def self.get_event_by_id event_id
    self.request("http://localhost:3000/events/#{event_id}", :get)
  end

  def self.request url, method
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    JSON.parse(conn.send(method, url).body, symbolize_names: true)
  rescue Faraday::Error => e
    raise e
  end
end