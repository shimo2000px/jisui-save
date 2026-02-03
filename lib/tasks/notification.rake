require "line/bot"
require "line/bot/v2/messaging_api/api/messaging_api_client"

namespace :notification do
  desc "LINEのリマインド通知を送信します"
  task send_reminders: :environment do
    puts "--- Notification Scan Start: #{Time.current} ---"

    now = Time.current.in_time_zone("Asia/Tokyo")
    day_of_week = now.strftime("%a").downcase

    puts "Checking for: Day=#{day_of_week}, Time=#{now.hour}:#{now.min}"

    all_enabled = NotificationSetting.includes(:user)
                                    .where("#{day_of_week} = ?", true)
                                    .where(enabled: true)

    targets = all_enabled.select do |setting|
      setting.send_time.in_time_zone("Asia/Tokyo").hour == now.hour &&
      setting.send_time.in_time_zone("Asia/Tokyo").min == now.min
    end
    puts "Found targets: #{targets.count}"

    line_creds = Rails.application.credentials.line

    if line_creds.nil? || line_creds[:messaging_token].nil?
      puts "Error: messaging_token not found in credentials."
    else
      client = Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: line_creds[:messaging_token]
      )

      targets.each do |setting|
        line_user_id = setting.user&.line_user_id
        next if line_user_id.blank?

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

          if response.respond_to?(:sent_messages)
            puts "Success! Message ID: #{response.sent_messages.first&.id}"
          else
            puts "Success: #{response.inspect}"
          end
        rescue => e
          puts "Error: #{e.message}"
        end
      end # ← ここに each に対する end が必要でした
    end

    puts "--- Scan Finished ---"
  end
end
