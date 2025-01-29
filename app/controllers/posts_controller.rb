class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_is_participant
  def new
    @post = Post.new
    @event_id = params[:event_id]
  end

  def create
    post_params = params.require(:post).permit(:title, :content)
    @post = Post.new(post_params)
    @post.event_id = params[:event_id]
    @post.user = current_user

    if @post.save
      redirect_to event_path(id: params[:event_id]), notice: t(".success")
    else
      @event_id = params[:event_id]
      flash.now[:alert] = t(".alert")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def check_user_is_participant
    unless Ticket.where(user: current_user, event_id: params[:event_id]).any?
      redirect_to root_path, alert: t(".negate_access")
    end
  end
end
