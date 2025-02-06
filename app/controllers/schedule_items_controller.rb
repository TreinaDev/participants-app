class ScheduleItemsController < ApplicationController
  def show
    @curriculum = Curriculum.request_curriculum_by_schedule_item_code(params[:id])
  end
end
