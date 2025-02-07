class ScheduleItem
  attr_accessor :name, :start_time, :end_time, :schedule_item_id, :description, :responsible_name, :responsible_email, :schedule_type
  def initialize(name:, start_time:, end_time:, schedule_item_id:, description:, responsible_name:, responsible_email:, schedule_type:)
    @name = name
    @start_time = start_time.to_datetime.strftime("%H:%M")
    @end_time = end_time.to_datetime.strftime("%H:%M")
    @schedule_item_id = schedule_item_id
    @start_time_raw = start_time.to_datetime
    @end_time_raw = end_time.to_datetime
    @description = description
    @responsible_email = responsible_email
    @responsible_name = responsible_name
    @schedule_type = schedule_type
  end

  def duration
    duration = ((@end_time_raw - @start_time_raw) * 24 * 60).to_i
    duration > 0 ? duration : 0
  end
end
