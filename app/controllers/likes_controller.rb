class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_is_participant
  before_action :check_user_owns_like, only: [ :destroy ]

  def create
    like = current_user.likes.build(post_id: params[:post_id])
    if like.save
      redirect_to request.referrer, notice: t(".success")
    end
  end

  def destroy
    @like = Like.find(params[:id])
    if @like.destroy
      redirect_to request.referrer, notice: t(".success")
    end
  end

  private

  def check_user_is_participant
    redirect_to root_path, alert: t(".negate_access") unless current_user.participates_in_event?(params[:event_id])
  end

  def check_user_owns_like
    unless current_user == Like.find(params[:id]).user
      redirect_to root_path, alert: t(".not_like_owner")
    end
  end
end
