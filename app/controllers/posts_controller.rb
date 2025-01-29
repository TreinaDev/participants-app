class PostsController < ApplicationController
  def new
    @post = Post.new
    @event_id = params[:event_id]
  end
end
