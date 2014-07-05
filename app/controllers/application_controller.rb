class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "Access reserveed for members only. Please sign in first."
      redirect_to sign_in_path
    end
  end

  def require_non_signed_in_user
    if logged_in?
      flash[:danger] = "You cannot access that page."
      redirect_to home_path
    end
  end
end
