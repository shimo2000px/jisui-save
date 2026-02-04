class NotificationsController < ApplicationController
  before_action :require_login

  def edit
    @setting = current_user.notification_setting || current_user.create_notification_setting
  end


  def update
    @setting = current_user.notification_setting || current_user.build_notification_setting

    p_hash = notification_params

    if p_hash[:send_time].present?
      begin
        @setting.send_time = Time.zone.parse(p_hash[:send_time])
      rescue
      end
    end

    @setting.assign_attributes(p_hash.except(:send_time))

    if @setting.save
      redirect_to profile_path, notice: "通知設定を保存しました"
    else
      flash.now[:alert] = "保存に失敗しました: #{@setting.errors.full_messages.join(', ')}"
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
