class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  include SessionsHelper

  before_action :require_login
  helper_method :current_user, :logged_in?
  helper_method :guest_user?
  private


  def require_login
    unless logged_in?
      flash[:danger] = "ログインが必要です"
      redirect_to login_path
    end
  end

  def current_user
    return @current_user if @current_user

    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end


  def guest_user?
    current_user&.email == "guest@example.com"
  end
end
