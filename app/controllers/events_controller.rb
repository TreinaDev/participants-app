class EventsController < ApplicationController
  def show
    @event = Event.request_event_by_id(params[:id])
    if @event.nil?
      flash[:alert] = "Evento não encontrado"
      redirect_to root_path
    end
  end
end
