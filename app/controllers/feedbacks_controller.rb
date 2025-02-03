class FeedbacksController < ApplicationController
  before_action :set_my_event_id
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.event_id = @my_event_id
    @feedback.user = current_user
    if @feedback.save
      flash[:notice] = "Feedback adicionado com sucesso"
      redirect_to my_event_feedbacks_path(my_event_id: @my_event_id)
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :comment, :mark, :public)
  end

  def set_my_event_id
    @my_event_id = params[:my_event_id]
  end
end
