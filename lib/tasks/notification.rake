require "line/bot"
require "line/bot/v2/messaging_api/api/messaging_api_client"

namespace :notification do
  desc "LINEのリマインド通知を送信します"
  task send_reminders: :environment do
    now = Time.find_zone("Asia/Tokyo").now
    day_of_week = now.strftime("%a").downcase # "tue"

    all_configs = NotificationSetting.includes(:user)
                                    .where("#{day_of_week} = ?", true)
                                    .where(enabled: true)

    targets = all_configs.select do |setting|
      jst_send_time = setting.send_time.in_time_zone("Asia/Tokyo")
      jst_send_time.hour == now.hour && jst_send_time.min == now.min
    end

    next if targets.empty?

    line_creds = Rails.application.credentials.line
    if line_creds.nil? || line_creds[:messaging_token].nil?
      Rails.logger.error "[Notification] Line credentials not found."
      next
    end

    client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: line_creds[:messaging_token]
    )

    targets.each do |setting|
      line_user_id = setting.user&.line_user_id
      if line_user_id.blank?
        Rails.logger.warn "[Notification] Skip User #{setting.user_id}: No LINE ID."
        next
      end

      action = Line::Bot::V2::MessagingApi::URIAction.new(
        label: "レシピを探す",
        uri: "https://jisui-save.onrender.com"
      )
      template = Line::Bot::V2::MessagingApi::ButtonsTemplate.new(
        text: "自炊の時間です！アプリからレシピを探しましょう🍳",
        actions: [ action ]
      )
      message = Line::Bot::V2::MessagingApi::TemplateMessage.new(
        type: "template",
        alt_text: "[自炊save]自炊の時間です🍳",
        template: template
      )
      push_request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
        to: line_user_id,
        messages: [ message ]
      )

      begin
        client.push_message(push_message_request: push_request)
        puts "[Notification] Sent to User ID: #{setting.user_id}"
      rescue => e
        Rails.logger.error "[Notification] Failed to send to User #{setting.user_id}: #{e.message}"
      end
    end
  end
end
