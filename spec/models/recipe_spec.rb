require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user) }
  let!(:recipe) { create(:recipe, user: user) }

  describe 'バリデーションのテスト' do
    it 'タイトル、ユーザー、コンビニ商品、材料があれば有効であること' do
      expect(recipe).to be_valid
    end

    it 'タイトルがない場合は無効であること' do
      recipe.title = nil
      expect(recipe).not_to be_valid
      expect(recipe.errors[:title]).to include("を入力してください")
    end
  end

  describe '編集・削除のテスト' do
    it 'レシピのタイトルを正常に更新できること' do
      recipe.update(title: "めんつゆで作る！親子丼")
      expect(recipe.reload.title).to eq "めんつゆで作る！親子丼"
    end

    it 'レシピを削除すると、DBからレシピが消えること' do
      expect { recipe.destroy }.to change(Recipe, :count).by(-1)
    end

    it 'レシピを削除すると、紐づく材料（recipe_ingredients）も連動して削除されること' do
      expect { recipe.destroy }.to change(RecipeIngredient, :count).by(-1)
    end
  end
end