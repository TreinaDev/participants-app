class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_and_batch, only: [ :new, :create, :show ]
  before_action :check_batch_is_sold_out?, only: [ :new, :create ]

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
      redirect_to event_batch_ticket_path(@event_id, @batch_id, @ticket.id), notice: t(".success")
    else
      flash.now[:notice] = t(".error")
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

  def check_batch_is_sold_out?
    if Batch.check_if_batch_is_sold_out(@event_id, @batch_id)
      redirect_to root_path, alert: t(".check_batch_is_sold_out?.alert")
    end
  end
end
