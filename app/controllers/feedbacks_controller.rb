class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_check_my_event_id
  before_action :check_user_is_participant

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
    else
      flash.now[:alert] = "Falha ao salvar o Feedback"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @feedbacks = Feedback.where(user: current_user, event_id: @my_event_id)
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :comment, :mark, :public)
  end

  def check_user_is_participant
    unless current_user.participates_in_event?(@my_event_id)
      redirect_to root_path, alert: "Vocẽ não participa deste evento"
    end
  end

  def set_and_check_my_event_id
    @my_event_id = params[:my_event_id]
    @event = Event.request_event_by_id(@my_event_id)
    redirect_to root_path, alert: "Este evento ainda está em andamento" if @event.end_date > Date.today
  end
end
