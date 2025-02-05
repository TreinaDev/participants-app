class Announcement
  attr_accessor :event_id, :announcement_id, :title, :description

  def initialize(event_id:, announcement_id:, title:, description:)
    @event_id = event_id
    @title = title
    @description = description
    @announcement_id = announcement_id
  end

  def self.request_announcement_by_id(event_id, announcement_id)
    announcement_params = EventsApiService.get_announcement_by_id(event_id, announcement_id)
    build_announcement(announcement_params)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    nil
  end

  def rich_text_description
    ActionText::Content.new(@description)
  end

  private

  def build_announcement(announcement)
    Announcement.new(announcement_id: announcement[:id], title: announcement[:title], description: announcement[:description], event_id: announcement[:event_id])
  end
end
