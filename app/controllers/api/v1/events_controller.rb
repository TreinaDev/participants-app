class Api::V1::EventsController < Api::V1::ApiController
  def show
    event_id = params[:id]
    unless Event.request_event_by_id(event_id)
      return render status: :not_found, json: { error: "Event not found" }
    end
    sold_tickets = Ticket.where(event_id: event_id).count
    render status: :ok, json: {
      id: event_id,
      sold_tickets: sold_tickets
    }
  end
end
