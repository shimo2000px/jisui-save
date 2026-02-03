class NotificationsController < ApplicationController
  before_action :require_login

  def edit
    @setting = current_user.notification_setting || current_user.create_notification_setting
  end

  def update
      logger.debug "--- DEBUG: Params received: #{params[:notification_setting].inspect} ---"
      @setting = current_user.notification_setting

      p_hash = notification_params
      if p_hash[:send_time].present?
        p_hash[:send_time] = Time.zone.parse(p_hash[:send_time])
      end

      if @setting.update(p_hash)
        redirect_to profile_path, notice: "通知設定を更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
  end

  private

  def notification_params
    params.require(:notification_setting).permit(
      :enabled, :send_time,
      :mon, :tue, :wed, :thu, :fri, :sat, :sun
    )
  end
end
