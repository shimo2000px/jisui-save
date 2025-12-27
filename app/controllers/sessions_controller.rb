class SessionsController < ApplicationController
  def new
  end

  def guest_login
  # ゲストユーザー時の分岐
  session[:user_id] = guest_user.id
  session[:is_guest] = true 
  
  redirect_to recipes_path, notice: "ゲストとしてログインしました（閲覧専用）"
  end

  def google_auth_callback
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by!(provider: auth.provider, uid: auth.uid) do |u|
      u.name = auth.info.name
      u.email = auth.info.email
      u.image_url = auth.info.image # Googleの画像URLを一旦保存
    end

    # Googleの画像をCloudinaryに転送して保存する処理
    if user.image_url.present? && !user.avatar.attached?
      require 'open-uri'
      file = URI.open(user.image_url)
      user.avatar.attach(io: file, filename: "user_#{user.uid}.jpg", content_type: 'image/jpg')
    end

    session[:user_id] = user.id
    redirect_to recipes_path, notice: "ログインしました！"
  end
end
