class EventsController < ApplicationController
  before_action :check_event, only: [ :show ]
  def show
    if @event.batches.any?
      batch_ids = @event.batches.map(&:batch_id)
      @total_tickets_sales = Ticket.where(batch_id: batch_ids).count
    end
    @posts = Post.where(event_id: params[:event_id])
  end

  def index
    if params[:query]
      @events = Event.search_events(params[:query]).select { |event| DateTime.now < event.start_date.to_datetime }
    else
      @events = Event.all.select { |event| DateTime.now < event.start_date.to_datetime }
    end
  end

  private

  def check_event
    @event = Event.request_event_by_id(params[:event_id])
    redirect_to root_path, alert: I18n.t("custom.generic.event_not_found") if @event.nil?
  end
end
