class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post_and_event, only: [ :create ]
  before_action -> { check_user_is_participant(@event_id) }, only: [ :create ]

  def create
    @comment = Comment.new(user: current_user, **params.require(:comment).permit(:content), post: @post)
    if @comment.save
      flash[:notice] = t(".success")
      redirect_to event_post_path(event_id: @event_id, id: @post.id)
    else
      flash[:alert] = t(".alert")
      render "posts/show", status: :unprocessable_entity
    end
  end

  private

  def set_post_and_event
    @post = Post.find(params[:post_id])
    @event_id = params[:event_id]
  end
end
