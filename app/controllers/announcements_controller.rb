class AnnouncementsController < ApplicationController
  def show
    @announcement = Announcement.request_announcement_by_id(params[:event_id], params[:id])
  end
end
