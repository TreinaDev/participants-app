class EventsController < ApplicationController
  def show
    @event = Event.request_event_by_id(params[:id])
  end
end
