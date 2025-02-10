class Api::V1::TicketsController < Api::V1::ApiController
  before_action :set_ticket_and_event
  before_action :check_ticket

  def used
    if @ticket.usable?
      @ticket.used!
      render status: 200, json: @ticket.as_json(except: [ :id, :created_at, :updated_at ])
      @ticket.ticket_usages.create!(date: Time.zone.now)
    elsif @ticket.used?
      render status: 422, json: { error: "This ticket is already used for this day" }
    elsif @ticket.not_the_date?
      render status: 404, json: { error: "This ticket can be used only on the day of the event" } unless DateTime.now.between?(@event.start_date, @event.end_date)
    end
  end

  private

  def set_ticket_and_event
    @ticket = Ticket.find_by(token: params[:token])
    @event = Event.request_event_by_id(@ticket.event_id)
  end

  def ticket_used_today?
    @ticket.ticket_usages.where(date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
  end

  def check_ticket
    unless ticket_used_today? > 0
      @ticket.usable!
    end
  end
end
