class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [ :show, :edit, :update ]
  before_action :set_profile, only: [ :show, :edit, :update ]

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to user_profile_path(user_id: @profile.user, id: @profile), notice: t(".notice")
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def check_user
    @user = User.find(params[:user_id])
    redirect_to root_path, alert: t(".negate_access") if current_user.id != @user.id
  end

  def profile_params
    params.require(:profile).permit(:city, :state, :phone_number)
  end
end
