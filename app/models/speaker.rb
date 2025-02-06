class Speaker
  attr_accessor :first_name, :last_name, :photo_url, :occupation, :profile_link
  def initialize(first_name:, last_name:, photo_url:, occupation:, profile_link:)
    @first_name = first_name
    @last_name = last_name
    @photo_url = photo_url
    @occupation = occupation
    @profile_link = profile_link
  end

  def self.request_speaker_by_schedule_item_id(schedule_item_id)
    speaker_params = SpeakersApiService.get_speaker(schedule_item_id)
    build_speaker(speaker_params[:speaker])
  rescue Faraday::Error => error
    Rails.logger.error(error)
    nil
  end

  private

  def self.build_speaker(speaker)
    Speaker.new(
      first_name: speaker[:first_name], last_name: speaker[:last_name], photo_url: speaker[:photo_url],occupation: speaker[:occupation], profile_link: speaker[:profile_link]
    )
  end
end
