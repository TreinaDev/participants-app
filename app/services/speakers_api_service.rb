class SpeakersApiService
  BASE_URL = "http://localhost:3003/api/v1"

  def self.get_curriculum_by_user(curriculum_code, user_code)
    self.request("#{BASE_URL}/curriculums/#{curriculum_code}/participants/#{user_code}", :get)
  end

  def self.get_speaker(email)
    self.request("#{BASE_URL}/speakers/#{email}", :get)
  end

  def self.post_complete_task(user_code, task_code)
    params = {
      participant_code: user_code,
      task_code: task_code
    }
    self.request("#{BASE_URL}/participant_tasks", :post, params)
  end

  def self.request(url, method, params = {})
    conn = Faraday.new do |faraday|
      faraday.response :raise_error
      faraday.adapter Faraday.default_adapter
    end
    response = if method == :post
                 conn.send(method, url, params.to_json) do |req|
                   req.headers["Content-Type"] = "application/json"
                 end
    else
      conn.send(method, url)
    end
    JSON.parse(response.body, symbolize_names: true)
  rescue Faraday::Error => e
    raise e
  end
end
