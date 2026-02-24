Rails.application.config.middleware.use OmniAuth::Builder do
  # LINEの設定
  provider :line,
    Rails.application.credentials.dig(:line, :channel_id),
    Rails.application.credentials.dig(:line, :channel_secret),

    {
      scope: "profile openid",
      authorize_params: {
        bot_prompt: "aggressive"
      }
    }

  # Googleの設定
  provider :google_oauth2,
    Rails.application.credentials.dig(:google, :client_id),
    Rails.application.credentials.dig(:google, :client_secret)
end
