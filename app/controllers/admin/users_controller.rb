class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :if_not_admin

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザーを削除しました"
  end

  private

  def if_not_admin
    redirect_to root_path, alert: "管理者専用です" unless current_user.admin?
  end
end
