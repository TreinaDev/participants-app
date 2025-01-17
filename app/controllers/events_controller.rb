class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.request_event_by_id(params[:id])
  end

  private

  def mock_events
    [
    Event.new(event_id: 1, name: "Dev Week", banner: "http://localhost:3000/events/1/banner.jpg",
    logo: "http://localhost:3000/events/1/logo.jpg", start_date: 2.days.from_now,
    end_date: 5.days.from_now),
    Event.new(event_id: 2, name: "Ruby Update", banner: "http://localhost:3000/events/2/banner.jpg",
    logo: "http://localhost:3000/events/2/logo.jpg", start_date: 5.days.from_now,
    end_date: 7.days.from_now)
    ]
  end
end
