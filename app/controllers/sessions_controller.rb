class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create, :guest_login ]

  def new
  end

  def create
    auth = request.env["omniauth.auth"]

    # 1. ログイン中の連携処理
    if current_user
      if auth.provider == "line"
        current_user.update!(line_user_id: auth.uid)
        # 連携後は通知設定ページへ飛ばすのが親切
        redirect_to edit_notification_path, notice: "LINEと連携しました！通知設定が可能です。"
      else
        redirect_to recipes_path, alert: "すでにログインしています。"
      end
      return
    end

    # 2. 未ログイン時の新規登録・ログイン処理
    user = User.find_or_create_by!(provider: auth.provider, uid: auth.uid) do |u|
      u.name = auth.info.name
      u.email = auth.info.email
      # LINEログインで始めた人は、最初からline_user_idを埋めておく
      u.line_user_id = auth.uid if auth.provider == "line"
    end

    session[:user_id] = user.id
    cookies.permanent.signed[:user_id] = user.id

    # 表示用名前の判定（google_oauth2 か line か）
    provider_name = auth.provider.include?("google") ? "Google" : "LINE"
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
