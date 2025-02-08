class Api::V1::UsersController < Api::V1::ApiController
  def show
    @user = User.find_by(code: params[:code])

    render status: :ok, json: @user.as_json(except: [ :password, :id, :created_at, :updated_at ])
  end
end
