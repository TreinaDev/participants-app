class Api::V1::BatchesController < Api::V1::ApiController
  def show
    batch_id = params[:id].to_i
    sold_tickets = Ticket.where(batch_id: params[:id]).count
    render status: :ok, json: { id: batch_id, sold_tickets: sold_tickets }
  end
end
