class ApplicationController < ActionController::Base
  rescue_from ActiveResource::ServerError, with: :server_error

  def server_error(ex)
    flash[:error] = "Server error with: #{ex.message}"
    redirect_to root_url
  end
end
