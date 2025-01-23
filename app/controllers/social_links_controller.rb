class SocialLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  before_action :set_profile

  def new
    @social_link = SocialLink.new
    @social_media = SocialMedium.all
  end

  def create
    @social_link = @profile.social_links.build(social_link_params)
    current_social_medium = @profile.social_links.find_by(social_medium_id: @social_link.social_medium_id)
    if current_social_medium
      update_current_social_medium(current_social_medium)
    else
      if @social_link.save
        flash[:notice] = t(".notice")
        redirect_to user_profile_path(user_id: @user, id: @profile)
      else
        @social_media = SocialMedium.all
        flash.now[:alert] = t(".alert")
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def check_user
    @user = User.find(params[:user_id])
    redirect_to root_path, alert: t(".negate_access") if current_user.id != @user.id
  end

  def social_link_params
    params.require(:social_link).permit(:social_medium_id, :url)
  end

  def update_current_social_medium(current_social_medium)
    if current_social_medium.update(social_link_params)
      flash[:notice] = t(".notice")
      redirect_to user_profile_path(user_id: @user, id: @profile)
    else
      @social_media = SocialMedium.all
      flash.now[:alert] = t(".alert")
      render :new, status: :unprocessable_entity
    end
  end
end
