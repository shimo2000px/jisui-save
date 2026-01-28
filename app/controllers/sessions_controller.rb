class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create, :guest_login ]

  def new
  end

def create
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_by!(provider: auth.provider, uid: auth.uid) do |u|
      u.name = auth.info.name
      u.email = auth.info.email
    end

    session[:user_id] = user.id
    cookies.permanent.signed[:user_id] = user.id

    provider_name = auth.provider == 'google_oauth2' ? 'Google' : 'LINE'
    redirect_to recipes_path, notice: "#{provider_name}でログインしました！"
  end
  def destroy
    session.delete(:user_id)
    cookies.delete(:user_id)
    @current_user = nil
    redirect_to login_path, notice: "ログアウトしました", status: :see_other
  end

  def guest_login
    user = User.find_or_create_by!(email: "guest@example.com") do |u|
      u.name = "ゲストユーザー"
      u.provider = "guest"
      u.uid = "guest"
    end
    session[:user_id] = user.id
    redirect_to recipes_path, notice: "ゲストとしてログインしました（閲覧専用）"
  end
end
