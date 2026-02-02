class NotificationsController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(notification_params)
      redirect_to profile_path, notice: "通知設定を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    @user.update(notification_enabled: false)
    redirect_to profile_path, notice: "通知をオフにしました"
  end

  private

  def notification_params
    params.require(:user).permit(
      :notification_enabled, :notification_time,
      :subscribe_mon, :subscribe_tue, :subscribe_wed,
      :subscribe_thu, :subscribe_fri, :subscribe_sat, :subscribe_sun
    )
  end
end
