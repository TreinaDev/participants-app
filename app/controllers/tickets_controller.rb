class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_and_batch, only: [ :new, :create, :show ]
  def new
    @ticket = Ticket.new
  end

  def create
    ticket_params = params.require(:ticket).permit(
      :payment_method
    )

    @ticket = current_user.tickets.build(ticket_params)
    @ticket.batch_id = @batch_id

    if @ticket.save
      redirect_to event_batch_ticket_path(@event_id, @batch_id, @ticket.id), notice: "Compra aprovada"
    else
      flash.now[:notice] = "Não foi possível realizar a compra"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
    @event = Event.request_event_by_id(@event_id)

    @qrcode = RQRCode::QRCode.new(@ticket.token)

    @svg = @qrcode.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )
  end

  private

  def set_event_and_batch
    @batch_id = params[:batch_id]
    @event_id = params[:event_id]
  end
end
