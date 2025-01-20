class SocialLinksController < ApplicationController
  before_action :set_profile_user

  def new
    @social_link = SocialLink.new()
  end

  def create
    @social_link = @profile.social_links.build(params.require(:social_link).permit(:name, :url))
    if @social_link.save
      flash[:notice] = t('.notice')
      redirect_to user_profile_path(user_id: @user, id: @profile)
    else
      puts @social_link.errors.full_messages
    end
  end

  private

  def set_profile_user
    @user = User.find(params[:user_id])
    @profile = Profile.find(params[:profile_id])
  end
end
