class SessionsController < ApplicationController
skip_before_action :require_login, only: [:new, :create, :guest_login]
  def new
  end

def create
  # OAuthの情報を取得
  auth = request.env['omniauth.auth']
  
  # ユーザーの保存・検索
  user = User.find_or_create_by!(provider: auth.provider, uid: auth.uid) do |u|
    u.name = auth.info.name
    u.email = auth.info.email
    u.image_url = auth.info.image
  end

  # 画像の保存処理（Cloudinaryへ）
  if user.image_url.present? && !user.avatar.attached?
    begin
      require 'open-uri'
      file = URI.open(user.image_url)
      user.avatar.attach(io: file, filename: "user_#{user.uid}.jpg", content_type: 'image/jpg')
    rescue => e
      logger.error "Cloudinary Upload Error: #{e.message}"
    end
  end

  # ログイン状態の保持
  session[:user_id] = user.id
  cookies.permanent.signed[:user_id] = user.id
  
  # リダイレクトはアクションの最後に「1回だけ」呼ぶ！
  redirect_to recipes_path, notice: "ログインしました！"
end

  def destroy
    log_out
    redirect_to login_path
  end

  def guest_login
  # ゲストユーザー時の分岐
  session[:user_id] = guest_user.id
  session[:is_guest] = true 
  
  redirect_to recipes_path, notice: "ゲストとしてログインしました（閲覧専用）"
  

    # Googleの画像をCloudinaryに転送して保存する処理
    if user.image_url.present? && !user.avatar.attached?
      require 'open-uri'
      file = URI.open(user.image_url)
      user.avatar.attach(io: file, filename: "user_#{user.uid}.jpg", content_type: 'image/jpg')
    end

    session[:user_id] = user.id
    redirect_to recipes_path, notice: "ログインしました！"
  end

  private

    def auth_hash
      request.env['omniauth.auth']
    end

    def find_or_create_from_auth_hash(auth_hash)
      email = auth_hash['info']['email']
      User.find_or_create_by(email: email) do |user|
        user.update(email: email)
      end
    end
end
