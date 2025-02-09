class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @favorite = current_user.favorites.build(event_id: params[:event_id])
    if @favorite.save
      redirect_back_or_to root_path, notice: t(".success")
    end
  end

  def index
    favorite_event_ids = current_user.favorites.pluck(:event_id)
    @favorites = Event.request_favorites(current_user.favorites).select { |event| favorite_event_ids.include?(event.event_id) }
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    if @favorite.user_id != current_user.id
      redirect_to root_path, alert: t(".alert")
    elsif @favorite.destroy!
      redirect_to favorites_path, notice: t(".success")
    end
  end
end
