class Api::V1::UsersController < Api::V1::ApiController
  def show
    if @user = User.find_by(code: params[:code])
      render status: :ok, json: @user.as_json(except: [ :password, :id, :created_at, :updated_at ])
    else
      render status: :not_found, json: { 'error': "User not found" }
    end
  end
end
