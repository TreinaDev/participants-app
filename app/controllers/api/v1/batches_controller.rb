class Api::V1::BatchesController < Api::V1::ApiController
  before_action :set_batch_and_event
  def show
    if Batch.get_batch_by_id(@event_id, @batch_id)
      sold_tickets = Ticket.where(batch_id: params[:id]).count
      render status: :ok, json: { id: @batch_id, sold_tickets: sold_tickets }
    else
      render status: :not_found, json: { error: "Batch not found" }
    end
  end

  private

  def set_batch_and_event
    @event_id = params[:event_id].to_i
    @batch_id = params[:id].to_i
  end
end
