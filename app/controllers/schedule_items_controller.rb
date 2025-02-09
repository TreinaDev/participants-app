class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_user_is_participant(params[:my_event_id]) }, only: [ :show ]
  def show
    user_code = current_user.code
    @curriculum = Curriculum.request_curriculum_by_schedule_item_code(params[:id], user_code)
  end
end
