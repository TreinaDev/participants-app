class EventsApiService
  BASE_URL = "http://localhost:4000/api/events"
  def self.get_events
    self.request(BASE_URL, :get)
  end

  def self.get_event_by_id(event_id)
    self.request("#{BASE_URL}/#{event_id}", :get)
  end

  def self.get_batches_by_event_id(event_id)
    self.request("#{BASE_URL}/#{event_id}/batches", :get)
  end

  def self.get_batch_by_id(event_id, batch_id)
    self.request("#{BASE_URL}/#{event_id}/batches/#{batch_id}", :get)
  end

  def self.request(url, method)
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
    end
    JSON.parse(conn.send(method, url).body, symbolize_names: true)
  rescue Faraday::Error => e
    raise e
  end
end
