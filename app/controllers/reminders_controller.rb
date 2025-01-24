class RemindersController < ApplicationController
  before_action :authenticate_user!

  def create
    set_reminder()
    if @reminder.save
      flash[:notice] = "Lembrete adicionado com sucesso"
      redirect_to request.referrer
    else
      flash.now[:alert] = @reminder.errors.full_messages.to_sentence
      redirect_to root_path
    end
  end

  private

  def set_reminder
    @reminder = Reminder.new
    @reminder.user = current_user
    event = Event.request_event_by_id(params[:event_id])
    if event.present? && event.batches.any?
      min_date_batch = event.batches.min_by { |batch| batch.start_date }.start_date
      @reminder.start_date = min_date_batch
    end
    @reminder.event_id = params[:event_id]
  end
end
