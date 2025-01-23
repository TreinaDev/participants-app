class BatchesController < ApplicationController
  before_action :authenticate_user!
  def index
    @batches = Batch.request_batches_by_event_id(params[:event_id])
    redirect_to event_path(params[:event_id]), alert: "Evento ainda não possui ingressos" if @batches.empty?
  end
end
