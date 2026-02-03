require "line/bot"
require "line/bot/v2/messaging_api/api/messaging_api_client"

namespace :notification do
  desc "LINEのリマインド通知を送信します"
  task send_reminders: :environment do
    now = Time.find_zone("Asia/Tokyo").now
    day_of_week = now.strftime("%a").downcase

    puts "--- [Task Start] Time: #{now.strftime('%H:%M:%S')}, Day: #{day_of_week} ---"

    all_configs = NotificationSetting.includes(:user)
                                    .where("#{day_of_week} = ?", true)
                                    .where(enabled: true)

    puts "Checked DB: Found #{all_configs.count} enabled configs for #{day_of_week}."

    targets = all_configs.select do |setting|
      jst_send_time = setting.send_time.in_time_zone("Asia/Tokyo")

      is_match = jst_send_time.strftime("%H:%M") == now.strftime("%H:%M")

      puts "  ID:#{setting.id} | User:#{setting.user_id} | Config:#{jst_send_time.strftime('%H:%M')} -> Match: #{is_match}"

      is_match
    end

    if targets.empty?
      puts "--- [Finished] No matching targets for this minute. ---"
      next
    end

    puts "Target found! Starting LINE Push..."

    line_creds = Rails.application.credentials.line
    if line_creds&.[](:messaging_token).nil?
      puts "ERROR: Line messaging_token is missing in credentials!"
      Rails.logger.error "[Notification] Line credentials not found."
      next
    end

    client = Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: line_creds[:messaging_token]
    )

    targets.each do |setting|
      line_user_id = setting.user&.line_user_id
      if line_user_id.blank?
        puts "  Skip User #{setting.user_id}: No LINE ID (line_user_id is nil)."
        next
      end

      action = Line::Bot::V2::MessagingApi::URIAction.new(label: "レシピを探す", uri: "https://jisui-save.onrender.com")
      template = Line::Bot::V2::MessagingApi::ButtonsTemplate.new(text: "自炊の時間です！🍳", actions: [ action ])
      message = Line::Bot::V2::MessagingApi::TemplateMessage.new(type: "template", alt_text: "自炊の時間です🍳", template: template)
      push_request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(to: line_user_id, messages: [ message ])

      begin
        client.push_message(push_message_request: push_request)
        puts "  SUCCESS: Sent to User ID #{setting.user_id}"
      rescue => e
        puts "  FAILED: User ID #{setting.user_id} - #{e.message}"
        Rails.logger.error "[Notification] Failed to send: #{e.message}"
      end
    end
    puts "--- [Task End] ---"
  end
end
