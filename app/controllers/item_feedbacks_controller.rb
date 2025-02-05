class ItemFeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_check_my_event_id
  before_action :set_schedule_item_id

  def new
    @item_feedback = ItemFeedback.new()
  end

  def create
    @item_feedback = ItemFeedback.new(item_feedback_params)
    @item_feedback.schedule_item_id = @schedule_item_id
    @item_feedback.event_id = @my_event_id
    @item_feedback.user = current_user
    if @item_feedback.save
      flash[:notice] = t(".success")
      redirect_to my_event_feedbacks_path(my_event_id: @my_event_id)
    else
      flash.now[:alert] = t(".alert")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_feedback_params
    params.require(:item_feedback).permit(:title, :comment, :mark, :public)
  end

  def set_and_check_my_event_id
    @my_event_id = params[:my_event_id]
    @event = Event.request_event_by_id(@my_event_id)
    redirect_to root_path, alert: t(".no_finished") if @event.end_date > Date.today
  end

  def set_schedule_item_id
    @schedule_item_id = params[:schedule_item_id]
    @schedule_item = @event.schedules.map { |schedule| schedule.schedule_item.map { |item_schedule| item_schedule.schedule_item_id } }
  end
end
