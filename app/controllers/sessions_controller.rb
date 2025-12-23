class SessionsController < ApplicationController
  def new
  end

  def guest_login
  # ゲストユーザー時の分岐
  session[:user_id] = guest_user.id
  session[:is_guest] = true 
  
  redirect_to recipes_path, notice: "ゲストとしてログインしました（閲覧専用）"
end
end
