class NotificationSettingsController < ApplicationController
  before_action :require_login

  def edit
    @setting = current_user.notification_setting || current_user.create_notification_setting
  end


  def update
    @setting = current_user.notification_setting || current_user.build_notification_setting

    p_hash = notification_params

    if p_hash[:send_time].present?
      hour, min = p_hash[:send_time].split(":")
      @setting.send_time = Time.zone.now.change(hour: hour.to_i, min: min.to_i)
    end

    @setting.assign_attributes(p_hash.except(:send_time))

    if @setting.save
      redirect_to profile_path, notice: "通知設定を保存しました"
    else
      Rails.logger.error "保存失敗: #{@setting.errors.full_messages}"
      flash.now[:alert] = "保存に失敗しました。入力内容を確認してください。"
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
