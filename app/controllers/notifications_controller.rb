class NotificationsController < ApplicationController
  before_action :require_login

  def edit
    @setting = current_user.notification_setting || current_user.create_notification_setting
  end

  def update
      @setting = current_user.notification_setting
      if @setting.update(notification_params)
        redirect_to profile_path, notice: "通知設定を更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    @setting = current_user
    @setting.update(notification_enabled: false)
    redirect_to profile_path, notice: "通知をオフにしました"
  end

  private

  def notification_params
    params.require(:notification_setting).permit(
      :enabled, :send_time,
      :mon, :tue, :wed, :thu, :fri, :sat, :sun
    )
  end
end
