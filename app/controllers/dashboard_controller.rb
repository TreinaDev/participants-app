class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    event_ids = current_user.tickets.where(status_confirmed: true).map(&:event_id)
    @posts = Post.where(event_id: event_ids).order(created_at: :desc).limit(10)
  end
end
