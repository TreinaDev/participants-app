class AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_user_is_participant(params[:event_id]) }

  def show
    @announcement = Announcement.request_announcement_by_id(params[:event_id], params[:id])
  end
end
