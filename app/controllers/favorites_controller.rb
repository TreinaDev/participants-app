class FavoritesController < ApplicationController
  before_action :check_if_user_is_authenticated, only: [ :create, :index, :destroy ]
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

  private

  def check_if_user_is_authenticated
    redirect_to new_user_session_path(locale: :'pt-BR'), alert: t(".check_user_is_authenticated.alert") unless user_signed_in?
  end
end
