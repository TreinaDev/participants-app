class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_is_participant
  before_action :set_event_id, only: [ :new, :create, :show ]

  def show
    @post = Post.find(params[:id])
    @number_of_likes = @post.likes.count
    @like = Like.find_by(user: current_user, post: @post)
  end

  def new
    @post = Post.new
  end

  def create
    post_params = params.require(:post).permit(:title, :content)
    @post = Post.new(post_params)
    @post.event_id = @event_id
    @post.user = current_user

    if @post.save
      redirect_to event_by_name_path(event_id: params[:event_id], name: Event.request_event_by_id(params[:event_id]).name.parameterize), notice: t(".success")
    else
      @event_id = params[:event_id]
      flash.now[:alert] = t(".alert")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_event_id
    @event_id = params[:event_id]
  end

  def check_user_is_participant
    unless current_user.participates_in_event?(params[:event_id])
      redirect_to root_path, alert: t(".negate_access")
    end
  end
end
