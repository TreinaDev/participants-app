class MyEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [ :show ]
  def index
    tickets = current_user.tickets.pluck(:event_id)
    @my_events = Event.request_my_events(current_user.tickets).select { |event| tickets.include?(event.event_id) }
  end

  def show
    @tickets_by_batch_id = Ticket.where(user: current_user, event_id: params[:id]).group_by { |event| event.batch_id }
    @batches = @tickets_by_batch_id.keys.each_with_object(Hash.new) { |batch_id, hash| hash[batch_id] = Batch.request_batch_by_id(params[:id], batch_id) }
    @event = Event.request_event_by_id(params[:id])
  end

  def check_user
    redirect_to root_path, alert: "Você não participa deste evento!" if Ticket.where(user: current_user, event_id: params[:id]).empty?
  end
end
