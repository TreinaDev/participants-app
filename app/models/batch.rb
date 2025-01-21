class Batch
  attr_accessor :batch_id, :name, :limit_tickets, :start_date, :value, :end_date, :event_id
  def initialize(batch_id:, name:, limit_tickets:, start_date:, value:, end_date:, event_id:)
    @batch_id = batch_id
    @name = name
    @limit_tickets = limit_tickets
    @start_date = start_date
    @value = value
    @end_date = end_date
    @event_id = event_id
  end

  private

  def self.build_batch(data)
    Batch.new(batch_id: data[:id], name: data[:name], limit_tickets: data[:limit_tickets],
              start_date: data[:start_date], value: data[:value], end_date: data[:value],
              event_id: data[:event_id])
  end
end
