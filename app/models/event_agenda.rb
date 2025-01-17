class EventAgenda
  attr_accessor :title, :date, :description, :instructor, :email, :start_time, :duration, :type, :event_agenda_id

  def initialize(event_agenda_id:, title:, date:, description:, instructor:, email:, start_time:, duration:, type:)
    @event_agenda_id = event_agenda_id
    @title = title
    @date = date
    @description = description
    @instructor = instructor
    @email = email
    @start_time = start_time
    @duration = duration
    @type = type
  end
end
