class Schedule
  attr_accessor :date, :schedule_items
  def initialize(date:, schedule_items:)
    @date = date
    @schedule_items = build_schedule_items(schedule_items)
  end

  private

  def build_schedule_items(schedule_items)
    schedule_items.map { |schedule_item| ScheduleItem.new(name: schedule_item[:name], start_time: schedule_item[:start_time],
                                                   end_time: schedule_item[:end_time])}
  end
end
