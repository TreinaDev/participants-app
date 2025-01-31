class ScheduleItem
  attr_accessor :name, :start_time, :end_time
  def initialize(name:, start_time:, end_time:)
    @name = name
    @start_time = start_time.to_datetime.strftime("%H:%M")
    @end_time = end_time.to_datetime.strftime("%H:%M")
  end
end
