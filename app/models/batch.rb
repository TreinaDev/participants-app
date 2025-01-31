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

  def sold_out?
    number_of_tickets_sold = Ticket.where(batch_id: batch_id).count
    limit_tickets <= number_of_tickets_sold
  end

  private

  def self.get_batch_by_id(event_id, batch_id)
    batch = EventsApiService.get_batch_by_id(event_id, batch_id)
    Batch.new(batch_id: batch[:code], name: batch[:name], limit_tickets: batch[:tickets_limit],
              start_date: batch[:start_date].to_date, value: batch[:ticket_price], end_date: batch[:end_date].to_date,
              event_id: event_id)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    nil
  end

  def self.request_batches_by_event_id(event_id)
    batches = EventsApiService.get_batches_by_event_id event_id
    batches_params = batches[:ticket_batches]
    self.build_batches(batches_params, event_id)
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.request_batch_by_id(event_id, batch_id)
    batch_params = EventsApiService.get_batch_by_id(event_id, batch_id)
    build_batches([ batch_params ], event_id).first
  rescue Faraday::Error => error
    Rails.logger.error(error)
    []
  end

  def self.build_batches(data, event_id)
    data.map { |batch| Batch.new(batch_id: batch[:code], name: batch[:name], limit_tickets: batch[:tickets_limit],
              start_date: batch[:start_date].to_date, value: batch[:ticket_price], end_date: batch[:end_date].to_date,
              event_id: event_id)}
  end

  def self.check_if_batch_is_sold_out(event_id, batch_id)
    number_of_tickets_sold = Ticket.where(batch_id: batch_id).count
    EventsApiService.get_batch_by_id(event_id, batch_id)[:tickets_limit] <= number_of_tickets_sold
  rescue
    true
  end
end
