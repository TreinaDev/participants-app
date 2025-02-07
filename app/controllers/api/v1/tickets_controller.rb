class Api::V1::TicketsController < Api::V1::ApiController
  before_action :set_ticket
  before_action :check_event

  def used
    unless @ticket.used?
      @ticket.used!
      render status: 200, json: @ticket.as_json(except: [ :id, :created_at, :updated_at ])
    else
      render status: 422, json: { error: "This ticket is already used for this day" }
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find_by(token: params[:token])
  end

  def check_ticket

  end
  
  def check_event
    event = Event.request_event_by_id(@ticket.event_id)
    render status: 404, json: { error: "This ticket can be used only on the day of the event" } unless DateTime.now.between?(event.start_date, event.end_date)
  end
end
