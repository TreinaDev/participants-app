class Speaker
  attr_accessor :first_name, :last_name, :role, :profile_image_url, :profile_url
  def initialize(first_name:, last_name:, role:, profile_image_url:, profile_url:)
    @first_name = first_name
    @last_name = last_name
    @role = role
    @profile_image_url = profile_image_url
    @profile_url = profile_url
  end

  def self.request_speakers_by_email(emails)
    speakers = []
    emails.each do |email|
      speakers << SpeakersApiService.get_speaker(email)
    end
    build_speakers(speakers)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    nil
  end

  private

  def self.build_speakers(speakers)
    speakers.map do |speaker|
      Speaker.new(
        first_name: speaker[:speaker][:first_name], last_name: speaker[:speaker][:last_name], role: speaker[:speaker][:role], profile_image_url: speaker[:speaker][:profile_image_url], profile_url: speaker[:speaker][:profile_url]
    )
    end
  end
end
