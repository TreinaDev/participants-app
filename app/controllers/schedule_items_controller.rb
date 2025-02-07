class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_user_is_participant(params[:my_event_id]) }, only: [ :show ]
  def show
    @curriculum = Curriculum.request_curriculum_by_schedule_item_code(params[:id])
  end
end
