class Speaker
  attr_accessor :first_name, :last_name, :photo_url, :occupation, :profile_link
  def initialize(first_name:, last_name:, photo_url:, occupation:, profile_link:)
    @first_name = first_name
    @last_name = last_name
    @photo_url = photo_url
    @occupation = occupation
    @profile_link = profile_link
  end

  def self.request_speaker_by_schedule_item_id(schedule_item_ids)
    speakers = []
    schedule_item_ids.each do |schedule_item_id|
      speakers << SpeakersApiService.get_speaker(schedule_item_id)
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
        first_name: speaker[:first_name], last_name: speaker[:last_name], photo_url: speaker[:photo_url], occupation: speaker[:occupation], profile_link: speaker[:profile_link]
    )
    end
  end
end
