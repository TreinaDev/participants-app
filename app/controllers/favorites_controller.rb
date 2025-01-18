class FavoritesController < ApplicationController
  before_action :check_user_is_authenticated, only: [ :create, :index ]
  def create
    @favorite = current_user.favorites.build(event_id: params[:event_id])
    if @favorite.save
      redirect_back_or_to root_path, notice: "Evento adicionado a favorito com sucesso"
    end
  end

  def index
    favorites = current_user.favorites
    @events_favorites = []
    favorites.each do |favorite|
      @events_favorites << Event.request_event_by_id(favorite.event_id)
    end
  end

  private
  def check_user_is_authenticated
    redirect_to new_user_session_path, alert: "Usuário não autenticado" unless user_signed_in?
  end
end
