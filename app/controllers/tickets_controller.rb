class TicketsController < ApplicationController
  def new
    @batch_id = params[:batch_id]
    @event_id = params[:event_id]
    @ticket = Ticket.new
  end
end
