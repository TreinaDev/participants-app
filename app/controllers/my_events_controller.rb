class MyEventsController < ApplicationController
  before_action :authenticate_user!
  def index
    tickets = current_user.tickets.pluck(:event_id)
    @my_events = Event.request_my_events(current_user.tickets).select { |event| tickets.include?(event.event_id) }
  end
end
