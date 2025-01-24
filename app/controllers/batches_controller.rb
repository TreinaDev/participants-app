class BatchesController < ApplicationController
  before_action :authenticate_user!
  def index
    @batches = Batch.request_batches_by_event_id(params[:event_id])
    redirect_to event_path(params[:event_id]), alert: I18n.t("custom.generic.batches_not_found") if @batches.empty?
  end
end
