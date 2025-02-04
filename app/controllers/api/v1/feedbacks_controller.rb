class Api::V1::FeedbacksController < Api::V1::ApiController
  before_action :set_and_check_event

  def index
    @feedbacks = Feedback.where(event_id: @event.event_id)
    if @feedbacks.any?
      feedback_json = @feedbacks.map { |feedback| { id: feedback.id, title: feedback.title,
                                                    comment: feedback.comment, mark: feedback.mark,
                                                    user: feedback.user.full_name } }
      render status: :ok, json: { event_id: @event.event_id, feedbacks: feedback_json }
    else
      render status: :not_found, json: { event_id: @event.event_id, error: "There is no feedbacks to this event yet" }
    end
  end

  private

  def set_and_check_event
    @event = Event.request_event_by_id(params[:event_id])
    return render status: :not_found, json: { error: "Event not found" } unless @event
    render status: :not_found, json: { event_id: @event.event_id, error: "This event is still ongoing" } if @event.end_date >= Date.today
  end
end
