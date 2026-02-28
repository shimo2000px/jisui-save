require "line/bot"
require "line/bot/v2/messaging_api/api/messaging_api_client"

namespace :notification do
  desc "LINEのリマインド通知を送信します"
  task send_reminders: :environment do
    now = Time.current.in_time_zone("Asia/Tokyo")
    day_of_week = now.strftime("%a").downcase

    puts "--- [Task Start] JST Time: #{now.strftime('%H:%M:%S')}, Day: #{day_of_week} ---"

    all_configs = NotificationSetting.includes(:user).where(enabled: true).to_a
    puts "DEBUG: Fetched #{all_configs.count} enabled settings from DB."

    targets = all_configs.select do |setting|
      next unless setting.send(day_of_week) == true
      # 時間設定を日本時間に設定
      config_time = setting.send_time.in_time_zone("Asia/Tokyo").strftime("%H:%M")
      current_time = now.strftime("%H:%M")

      is_match = (config_time == current_time)
      puts "  SettingID:#{setting.id} | User:#{setting.user_id} | Config:#{config_time} | Now:#{current_time} -> Match: #{is_match}"
      is_match
    end

    if targets.empty?
      puts "--- [Finished] No matching targets for this minute. ---"
      next
    end

    line_creds = Rails.application.credentials.line
    if line_creds&.[](:messaging_token).nil?
      puts "ERROR: Line messaging_token is missing!"
      next
    end

    client = Line::Bot::V2::MessagingApi::ApiClient.new(channel_access_token: line_creds[:messaging_token])

    targets.each do |setting|
      line_user_id = setting.user&.line_user_id
      next if line_user_id.blank?

      action = Line::Bot::V2::MessagingApi::URIAction.new(label: "レシピを探す", uri: "https://jisui-save.com")
      template = Line::Bot::V2::MessagingApi::ButtonsTemplate.new(text: "今日の献立どうする？", actions: [ action ])
      message = Line::Bot::V2::MessagingApi::TemplateMessage.new(type: "template", alt_text: "自炊の時間になりました🍳", template: template)
      push_request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(to: line_user_id, messages: [ message ])

      begin
        client.push_message(push_message_request: push_request)
        puts "  SUCCESS: Sent to User ID #{setting.user_id}"
      rescue => e
        puts "  FAILED: User ID #{setting.user_id} - #{e.message}"
      end
    end
    puts "--- [Task End] ---"
  end
end
