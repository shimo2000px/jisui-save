require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    it '名前、provider、uidがあれば有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end  

    it '名前がない場合は無効であること' do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("を入力してください")
    end
  end

  describe '各パターンのFactoryチェック' do
    it 'ゲストユーザーのtraitが有効であること' do
      guest_user = build(:user, :guest)
      expect(guest_user.provider).to eq 'guest'
      expect(guest_user.email).to eq 'guest@example.com'
      expect(guest_user).to be_valid
    end

    it 'LINEユーザーのtraitが有効であること' do
      line_user = build(:user, :line)
      expect(line_user.provider).to eq 'line'
      expect(line_user.line_user_id).not_to be_nil
      expect(line_user).to be_valid
    end
  end
    
  describe 'バリデーションエラーのテスト' do
    it 'providerがない場合は無効であること' do
        user = build(:user, provider: nil)
        expect(user).not_to be_valid
        expect(user.errors[:provider]).to include("を入力してください")
      end

      it 'uidがない場合は無効であること' do
        user = build(:user, uid: nil)
        expect(user).not_to be_valid
        expect(user.errors[:uid]).to include("を入力してください")
      end

      it '同じproviderとuidの組み合わせが既に存在する場合は無効であること' do
        create(:user, provider: 'google_oauth2', uid: '12345')
        duplicate_user = build(:user, provider: 'google_oauth2', uid: '12345')
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:uid]).to include("はすでに存在します")
    end
  end

  describe 'アソシエーションのテスト' do
    let!(:user) { create(:user) }

    it 'ユーザーを削除すると、紐づくレシピも削除されること' do
      create(:recipe, user: user)
      expect { user.destroy }.to change(Recipe, :count).by(-1)
    end

    it 'ユーザーを削除すると、紐づく通知設定も削除されること' do
      expect { user.destroy }.to change(NotificationSetting, :count).by(-1) 
    end
  end
end