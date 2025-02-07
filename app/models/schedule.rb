class Schedule
  attr_accessor :date, :schedule_items
  def initialize(date:, schedule_items:)
    @date = date.to_date
    @schedule_items = build_schedule_items(schedule_items)
  end

  private

  def build_schedule_items(schedule_items)
    schedule_items.map { |schedule_item| ScheduleItem.new(schedule_item_id: schedule_item[:code], name: schedule_item[:name], start_time: schedule_item[:start_time],
                                                   end_time: schedule_item[:end_time], description: schedule_item[:description], responsible_name: schedule_item[:responsible_name], responsible_email: schedule_item[:responsible_email], schedule_type: schedule_item[:schedule_type])}
  end
end
