class Api::V1::FeedbackAnswersController < Api::V1::ApiController
  def create
    @feedback_answers = FeedbackAnswer.new(feedback_answers_params)
    if @feedback_answers.save
      render status: 201, json: @feedback_answers.as_json
    end
  end

  private

  def feedback_answers_params
    params.require(:feedback_answers).permit(:name, :email, :comment, :item_feedback_id)
  end
end
