class RemindersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [ :destroy ]
  before_action :set_and_check_event, only: [ :create ]
  before_action :set_reminder, only: [ :create ]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    @reminder.save
    flash[:notice] = t(".success")
    redirect_to request.referrer
    set_mailer if @reminder.start_date
  end

  def destroy
    if @reminder.destroy
      flash[:notice] = t(".success")
      redirect_to request.referrer
    end
  end

  private

  def start_selling_date
    @event.batches.min_by { |batch| batch.start_date }.start_date
  end

  def set_reminder
    @reminder = Reminder.new(user: current_user, start_date: start_selling_date,
                             event_id: params[:event_id])
  end

  def set_and_check_event
    @event = Event.request_event_by_id(params[:event_id])
    redirect_to root_path, alert: t(".no_batch_or_events_avaliable") if @event.nil? || @event.batches.empty?
  end

  def set_mailer
    RemindersMailer.with(user: @reminder.user.id, event: params[:event_id]).ticket_reminder.deliver_later(
                         wait_until: @reminder.start_date.to_datetime)
  end

  def check_user
    @reminder = Reminder.find(params[:id])
    if current_user.id != @reminder.user_id
      flash[:alert] = t(".alert")
      redirect_to root_path
    end
  end

  def handle_record_not_found
    redirect_to root_path
  end
end
