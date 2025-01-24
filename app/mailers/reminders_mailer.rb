class RemindersMailer < ApplicationMailer
  default from: "ingressos@contato.com"

  def ticket_reminder
    @user = User.find(params[:user])
    @event = Event.request_event_by_id(params[:event])

    mail(to: @user.email, subject: t(".subject"))
  end
end
