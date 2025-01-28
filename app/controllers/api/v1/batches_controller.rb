class Api::V1::BatchesController < Api::V1::ApiController
  def show
    begin
      batch_id = params[:id].to_i
      sold_tickets = Ticket.where(batch_id: params[:id]).count
      render status: 200, json: { id: batch_id, sold_tickets: sold_tickets }
    rescue
      render status: 400
    end
  end
end
