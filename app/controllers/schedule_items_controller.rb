class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  def show
    @curriculum = Curriculum.request_curriculum_by_schedule_item_code(params[:id])
  end
end
