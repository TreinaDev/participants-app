class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500

  def return_500
    render status: :internal_server_error, json: { error: "An unexpected error occurred" }
  end
end
