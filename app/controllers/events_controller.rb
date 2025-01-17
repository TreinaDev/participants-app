class EventsController < ApplicationController
  def index
    @events = mock_events
  end

  def show
    @event = Event.request_event_by_id(params[:id])
  end

  private

  def mock_events
    [
    Event.new(event_id: 1, name: "Dev Week", banner: "https://img.freepik.com/vector-gratis/banner-negocios-generales_23-2148994466.jpg",
    logo: "https://i.pinimg.com/736x/d3/49/36/d349363dc3c7297aa97363e6ec641d9d.jpg", start_date: 2.days.from_now,
    end_date: 5.days.from_now),
    Event.new(event_id: 2, name: "Ruby Update", banner: "https://img.freepik.com/psd-gratuitas/modelo-de-banner-horizontal-para-conscientizacao-do-dia-da-aids_23-2149141293.jpg",
    logo: "https://i.pinimg.com/736x/d3/49/36/d349363dc3c7297aa97363e6ec641d9d.jpg", start_date: 5.days.from_now,
    end_date: 7.days.from_now)
    ]
  end
end
