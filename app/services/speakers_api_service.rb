class SpeakersApiService
  BASE_URL = "http://localhost:3003/api/v1"

  def self.get_curriculum(curriculum_code)
    self.request("#{BASE_URL}/curriculums/#{curriculum_code}", :get)
  end

  def self.get_speaker(schedule_item_id)
    self.request("#{BASE_URL}/schedule_items/#{schedule_item_id}", :get)
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
