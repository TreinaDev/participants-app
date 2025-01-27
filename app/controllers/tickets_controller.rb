class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_and_batch, only: [ :new, :create ]
  def new
    @ticket = Ticket.new
  end

  def create
    ticket_params = params.require(:ticket).permit(
      :payment_method
    )

    @ticket = current_user.tickets.build(ticket_params)
    @ticket.batch_id = @batch_id
    @ticket.event_id = @event_id

    if @ticket.save
      redirect_to root_path, notice: "Compra aprovada"
    else
      flash.now[:notice] = "Não foi possível realizar a compra"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_event_and_batch
    @batch_id = params[:batch_id]
    @event_id = params[:event_id]
  end
end
