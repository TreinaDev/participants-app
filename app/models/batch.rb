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

  def self.request_batches_by_event_id(event_id)
    batches_params = EventsApiService.get_batches_by_event_id event_id
    build_batches(batches_params)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.request_batch_by_id(event_id, batch_id)
    batch_params = EventsApiService.get_batch_by_id(event_id, batch_id)
    build_batch(batch_params)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.build_batches(data)
    data.map { |batch| Batch.new(batch_id: batch[:id], name: batch[:name], limit_tickets: batch[:limit_tickets],
              start_date: batch[:start_date].to_date, value: batch[:value], end_date: batch[:end_date].to_date,
              event_id: batch[:event_id])}
  end
end
