class SocialLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  before_action :set_profile

  def new
    @social_link = SocialLink.new()
  end

  def create
    @social_link = @profile.social_links.build(params.require(:social_link).permit(:name, :url))
    if @social_link.save
      flash[:notice] = t(".notice")
      redirect_to user_profile_path(user_id: @user, id: @profile)
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
end
