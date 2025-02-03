class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post_and_event_id, only: [ :show, :edit, :update ]
  before_action :check_user_is_participant
  before_action :set_event_id, only: [ :new, :create ]
  before_action :check_user_owns_post, only: [ :edit, :update ]

  def show
    @number_of_likes = @post.likes.count
    @like = Like.find_by(user: current_user, post: @post)
  end

  def new
    @post = Post.new
  end

  def create
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

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = t(".success")
      redirect_to event_by_name_path(event_id: @event_id, name: Event.request_event_by_id(params[:event_id]).name.parameterize)
    else
      flash[:alert] = t(".alert")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_event_id
    @event_id = params[:event_id]
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_post_and_event_id
    @event_id = params[:event_id]
    @post = Post.find(params[:id])
  end

  def check_user_owns_post
    unless @post.user == current_user
      redirect_to root_path, alert: t(".not_post_owner")
    end
  end

  def check_user_is_participant
    unless current_user.participates_in_event?(params[:event_id])
      redirect_to root_path, alert: t(".not_participant")
    end
  end
end
