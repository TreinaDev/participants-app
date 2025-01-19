class FavoritesController < ApplicationController
  before_action :check_user_is_authenticated, only: [ :create, :index, :destroy ]
  def create
    @favorite = current_user.favorites.build(event_id: params[:event_id])
    if @favorite.save
      redirect_back_or_to root_path, notice: "Evento adicionado a favorito com sucesso"
    end
  end

  def index
    @favorites = Event.request_favorites(current_user.favorites)
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    if @favorite.destroy!
      redirect_to favorites_path, notice: "Evento Desfavoritado"
    end
  end

  private

  def check_user_is_authenticated
    redirect_to new_user_session_path, alert: "Usuário não autenticado" unless user_signed_in?
  end
end
