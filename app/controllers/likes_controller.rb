class LikesController < ApplicationController
  def create
    like = current_user.likes.build(post_id: params[:post_id])
    if like.save
      redirect_to request.referrer, notice: t(".success")
    else
      redirect_to request.referrer, alert: t(".alert")
    end
  end
end
