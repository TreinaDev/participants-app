class RemindersController < ApplicationController
  before_action :authenticate_user!

  def create
    @reminder = Reminder.new
    @reminder.user = current_user
    @reminder.start_date = params[:start_date]
    @reminder.event_id = params[:event_id]
    if @reminder.save
      flash[:notice] = "Lembrete adicionado com sucesso"
      redirect_to request.referrer
    end
  end
end
