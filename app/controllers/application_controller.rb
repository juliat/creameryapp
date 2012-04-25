class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # authentication methods
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  # make current_user a helper method so that it's accessible to the views
  helper_method :current_user
  
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end
  
end
