require "line/bot"

class LineBotService
  def initialize
    @client ||= ::Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line[:messaging_secret]
      config.channel_token = Rails.application.credentials.line[:messaging_token]
    }
  end

  def send_message(line_user_id, message)
    return if line_user_id.blank?

    response = @client.push_message(line_user_id, message)
    response.code
  end
end
