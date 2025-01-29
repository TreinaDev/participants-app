class BatchesController < ApplicationController
  before_action :authenticate_user!
  def index
    @batches = Batch.request_batches_by_event_id(params[:event_id])
    @event = Event.request_event_by_id(params[:event_id])
    redirect_to event_by_name_path(id: @event.event_id, name: @event.name.parameterize), alert: I18n.t("custom.generic.batches_not_found") if @batches.empty?
  end
end
