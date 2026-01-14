class CookingRecordsController < ApplicationController
  before_action :require_login

  def create
    if guest_user?
        redirect_to recipe_path(params[:recipe_id]), alert: "自炊を記録するにはアカウントログインが必要です"
        return
    end

    @recipe = Recipe.find(params[:recipe_id])

    @cooking_record = current_user.cooking_records.build(
      recipe: @recipe,
      cooking_cost: @recipe.total_cost,
      convenience_cost: @recipe.convenience_food&.price || 0,
      cooked_at: Time.current
    )

    if @cooking_record.save
      redirect_to recipe_path(@recipe), notice: "自炊お疲れ様です！記録しました。"
    else
      redirect_to recipe_path(@recipe), alert: "記録に失敗しました。"
    end
  end
end
