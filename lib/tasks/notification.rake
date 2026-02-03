require "line/bot"
require "line/bot/v2/messaging_api/api/messaging_api_client"

namespace :notification do
  desc "LINEのリマインド通知を送信します"
  task send_reminders: :environment do
    now = Time.find_zone("Asia/Tokyo").now
    day_of_week = now.strftime("%a").downcase # "tue"

    puts "--- Notification Scan Start: #{now} ---"
    puts "Checking for: Day=#{day_of_week}, Time=#{now.strftime('%H:%M')}"

    all_configs = NotificationSetting.includes(:user)
                                    .where("#{day_of_week} = ?", true)
                                    .where(enabled: true)

    puts "Total enabled configs for #{day_of_week}: #{all_configs.count}"

    targets = all_configs.select do |setting|
      jst_send_time = setting.send_time.in_time_zone("Asia/Tokyo")

      puts "ID: #{setting.id} | DB Time (JST): #{jst_send_time.strftime('%H:%M')}"

      jst_send_time.hour == now.hour && jst_send_time.min == now.min
    end

    puts "Found matching targets: #{targets.count}"

    line_creds = Rails.application.credentials.line
    if line_creds.nil? || line_creds[:messaging_token].nil?
      puts "Error: messaging_token not found in credentials."
    else
      client = Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: line_creds[:messaging_token]
      )

      targets.each do |setting|
        line_user_id = setting.user&.line_user_id
        if line_user_id.blank?
          puts "Skip ID: #{setting.id} - No line_user_id found."
          next
        end

        puts "Sending to User ID: #{setting.user_id}..."

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
          response = client.push_message(push_message_request: push_request)
          puts "Success! Message sent to #{line_user_id}"
        rescue => e
          puts "Error sending to User #{setting.user_id}: #{e.message}"
        end
      end
    end

    puts "--- Scan Finished ---"
  end
end
