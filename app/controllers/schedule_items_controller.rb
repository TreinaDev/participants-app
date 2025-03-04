class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_user_is_participant(params[:my_event_id]) }, only: [ :show ]
  def show
    user_code = current_user.code
    @schedule_item_id = params[:id]
    @curriculum = Curriculum.request_curriculum_by_schedule_item_and_user_code(params[:id], user_code)
  end

  def complete_task
    user_code = current_user.code
    response = Curriculum.request_finalize_task(user_code, params[:task_code])
    @schedule_item_id = params[:id]
    @curriculum = Curriculum.request_curriculum_by_schedule_item_and_user_code(params[:id], user_code)
    if response[:ok]
      flash[:notice] = t(".task_suceffully_completed")
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = t(".task_status_unchanged")
      render :show, status: :unprocessable_entity
    end
  end
end
