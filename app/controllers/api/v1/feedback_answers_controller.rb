class Api::V1::FeedbackAnswersController < Api::V1::ApiController
  before_action :set_and_check_item_feedback

  def create
    @feedback_answers = FeedbackAnswer.new(feedback_answers_params)
    @feedback_answers.item_feedback = @item_feedback
    if @feedback_answers.save
      render status: 201, json: @feedback_answers.as_json
    else
      render status: 406, json: { errors: I18n.with_locale(:en) { @feedback_answers.errors.full_messages } }
    end
  end

  private

  def feedback_answers_params
    params.require(:feedback_answer).permit(:name, :email, :comment)
  end

  def set_and_check_item_feedback
    @item_feedback = ItemFeedback.find(params[:item_feedback_id])
  rescue
    render status: 404, json: { error: "Item feedback not found" }
  end
end
