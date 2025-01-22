class TicketsController < ApplicationController
  before_action :authenticate_user!
  def new
    @batch_id = params[:batch_id]
    @event_id = params[:event_id]
    @ticket = Ticket.new
  end

  def create
    ticket_params = params.require(:ticket).permit(
      :payment_method
    )

    @ticket = current_user.tickets.build(ticket_params)
    @ticket.batch_id = params[:batch_id]

    if @ticket.save
      redirect_to root_path, notice: "Compra aprovada"
    else
      @batch_id = params[:batch_id]
      @event_id = params[:event_id]
      flash.now[:notice] = "Não foi possível realizar a compra"
      render :new, status: :unprocessable_entity
    end
  end
end
