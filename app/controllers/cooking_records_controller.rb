class CookingRecordsController < ApplicationController
  # authenticate_user! ではなく、ApplicationController で定義した require_login を使う
  before_action :require_login

  def create
    @recipe = Recipe.find(params[:recipe_id])

    # ログイン中のユーザー（current_user）に関連付けて保存
    @cooking_record = current_user.cooking_records.build(
      recipe: @recipe,
      cooking_cost: @recipe.total_cost,
      convenience_cost: @recipe.convenience_food&.price || 0,
      cooked_at: Time.current
    )

    if @cooking_record.save
      redirect_to recipe_path(@recipe), notice: "自炊えらい！記録しました。"
    else
      redirect_to recipe_path(@recipe), alert: "記録に失敗しました。"
    end
  end
end
