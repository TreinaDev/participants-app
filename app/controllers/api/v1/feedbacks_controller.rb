class Api::V1::FeedbacksController < Api::V1::ApiController
  before_action :set_and_check_event

  def index
    @item_feedbacks = ItemFeedback.where(event_id: @event.event_id)
    @feedbacks = Feedback.where(event_id: @event.event_id)
    if @feedbacks.any? || @item_feedbacks.any?
      item_feedbacks = @item_feedbacks.map { |item_feedback| { id: item_feedback.id, title: item_feedback.title,
                                                               comment: item_feedback.comment, mark: item_feedback.mark,
                                                               user: item_feedback.user.full_name,
                                                               schedule_item_id: item_feedback.schedule_item_id } }

      feedback_json = @feedbacks.map { |feedback| { id: feedback.id, title: feedback.title,
                                                    comment: feedback.comment, mark: feedback.mark,
                                                    user: feedback.user_identification } }

      render status: :ok, json: { event_id: @event.event_id, feedbacks: feedback_json, item_feedbacks: item_feedbacks }
    else
      render status: :not_found, json: { event_id: @event.event_id, error: "There is no feedbacks to this event yet" }
    end
  end

  private

  def set_and_check_event
    @event = Event.request_event_by_id(params[:event_id])
    return render status: :not_found, json: { error: "Event not found" } unless @event
    render status: :not_found, json: { event_id: @event.event_id, error: "This event is still ongoing" } if @event.end_date >= DateTime.now
  end
end
