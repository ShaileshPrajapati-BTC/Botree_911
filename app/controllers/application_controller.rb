class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :restrict_access, unless: :signin_action?

  def restrict_access
    if params.keys.include?("access_token")
      @current_user = User.find_by_access_token(params[:access_token])
      render :json => {:status => false, :invalid => "invalid access token"} unless @current_user
    end
  end

  def signin_action?
    ['/', '/users/sign_in'].include?(request.path) && params.keys.include?("fcm_token")
  end
end