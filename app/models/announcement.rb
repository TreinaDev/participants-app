class Announcement
  attr_accessor :created_at, :announcement_id, :title, :description

  def initialize(created_at:, announcement_id:, title:, description:)
    @created_at = created_at
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

  def self.request_announcements_by_event_id(event_id)
    announcement_params = EventsApiService.get_announcements_by_event_id(event_id)
    announcement_params.map { |announcement| build_announcement(announcement) }
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def rich_text_description
    ActionText::Content.new(@description)
  end

  private

  def build_announcement(announcement)
    Announcement.new(announcement_id: announcement[:code], title: announcement[:title], description: announcement[:description], created_at: announcement[:created_at])
  end
end
