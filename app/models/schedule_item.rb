class ScheduleItem
  attr_accessor :name, :start_time, :end_time
  def initialize(name:, start_time:, end_time:)
    @name = name
    @start_time = start_time.to_datetime.strftime("%H:%M")
    @end_time = end_time.to_datetime.strftime("%H:%M")
    @start_time_raw = start_time.to_datetime
    @end_time_raw = end_time.to_datetime
  end

  def duration
    duration = ((@end_time_raw - @start_time_raw) * 24 * 60).to_i
    duration > 0 ? duration : 0
  end
end
