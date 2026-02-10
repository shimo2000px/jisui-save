require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  subject { build(:recipe_ingredient) }

  describe 'バリデーションのテスト' do
    it '食材があれば有効であること' do
      is_expected.to be_valid
    end

    it '食材がない場合は無効であること' do
      subject.ingredient = nil
      subject.valid?
      expect(subject.errors[:ingredient]).to include("を選択してください")
    end
  end
end