class MyEventsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_user_is_participant(params[:id]) }, only: [ :show ]

  def index
    @event_ids = current_user.tickets.pluck(:event_id).uniq
    @my_events = @event_ids.map { |event_id| Event.request_event_by_id(event_id) }.select { |event| @event_ids.include?(event.event_id) if event }
  end

  def show
    @tickets_by_batch_id = Ticket.where(user: current_user, event_id: params[:id]).group_by { |event| event.batch_id }
    @batches = @tickets_by_batch_id.keys.each_with_object(Hash.new) { |batch_id, hash| hash[batch_id] = Batch.request_batch_by_id(params[:id], batch_id) }
    @event = Event.request_event_by_id(params[:id])
    @posts = Post.where(event_id: params[:id])
    @feedbacks = Feedback.where(event_id: params[:id], public: true)
    @item_feedbacks = ItemFeedback.where(event_id: params[:id], public: true)
    @announcements = Announcement.request_announcements_by_event_id(@event.event_id)
  end
end
