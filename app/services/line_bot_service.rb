require "line/bot"

class LineBotService
  def initialize
    @client ||= ::Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def send_message(line_user_id, message)
    return if line_user_id.blank?

    response = @client.push_message(line_user_id, message)
    response.code
  end
end
