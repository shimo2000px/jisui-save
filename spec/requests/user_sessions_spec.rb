require 'rails_helper'

RSpec.describe "ユーザー認証", type: :request do
  describe "Googleログイン" do
    it "正常にログイン・ログアウトができること" do
      post "/auth/google_oauth2"
      follow_redirect! 
      expect(response).to redirect_to(recipes_path)
      follow_redirect!
      expect(response.body).to include "ログアウト"

      delete logout_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include "ログイン"
    end
  end

  describe "LINEログイン" do
    it "正常にログイン・ログアウトができること" do
      post "/auth/line"
      follow_redirect! 
      expect(response).to redirect_to(recipes_path)
      follow_redirect!
      expect(response.body).to include "ログアウト"

      delete logout_path
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include "ログイン"
    end
  end

  describe "認証の失敗" do
    it "認証をキャンセルした場合、ログインページにリダイレクトされること" do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      post "/auth/google_oauth2"
      follow_redirect!
      expect(response).to redirect_to(%r{/auth/failure})
    end
  end
end