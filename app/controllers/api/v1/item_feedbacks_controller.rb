class Api::V1::ItemFeedbacksController < Api::V1::ApiController
  def index
    @item_feedbacks = ItemFeedback.where(schedule_item_id: params[:schedule_item_id])
    if @item_feedbacks.any?
      item_feedbacks = @item_feedbacks.map { |item_feedback| { id: item_feedback.id, title: item_feedback.title,
                                                               comment: item_feedback.comment, mark: item_feedback.mark,
                                                               user: item_feedback.user.full_name,
                                                               schedule_item_id: item_feedback.schedule_item_id } }

      render status: :ok, json: { item_feedbacks: item_feedbacks }
    else
      render status: :not_found, json: { schedule_item_id: params[:schedule_item_id], error: "Feedback items not found" }
    end
  end
end
