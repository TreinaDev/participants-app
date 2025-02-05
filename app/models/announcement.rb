class Announcement
  attr_accessor :event_id, :announcement_id, :title, :description

  def initialize(event_id:, announcement_id:, title:, description:)
    @event_id = event_id
    @title = title
    @description = description
    @announcement_id = announcement_id
  end

  def rich_text_description
    ActionText::Content.new(@description)
  end
end
