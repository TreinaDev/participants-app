class EventsApiService
  BASE_URL = "http://localhost:3000/api/v1/events"
  def self.get_events(query_string = "")
    url = query_string.present? ? BASE_URL + "?query=" + query_string : BASE_URL
    self.request(url, :get)
  end

  def self.get_event_by_id(event_id)
    self.request("#{BASE_URL}/#{event_id}", :get)
  end

  def self.get_batches_by_event_id(event_id)
    self.request("#{BASE_URL}/#{event_id}/ticket_batches", :get)
  end

  def self.get_batch_by_id(event_id, batch_id)
    self.request("#{BASE_URL}/#{event_id}/ticket_batches/#{batch_id}", :get)
  end

  def self.get_announcements_by_event_id(event_id)
    self.request("#{BASE_URL}/#{event_id}/announcements", :get)
  end

  def self.get_announcement_by_id(event_id, announcement_id)
    self.request("#{BASE_URL}/#{event_id}/announcements/#{announcement_id}", :get)
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
