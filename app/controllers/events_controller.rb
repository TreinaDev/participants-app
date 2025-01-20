class EventsController < ApplicationController
  def show
    @event = Event.request_event_by_id(params[:id])
    if @event.nil?
      flash[:alert] = "Evento não encontrado"
      redirect_to root_path
    end
  end

  def index
    @events = Event.all.select { |event| event.start_date > Date.today }
  end
end
