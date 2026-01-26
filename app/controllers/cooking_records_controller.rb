class CookingRecordsController < ApplicationController
  before_action :require_login

  def create
    if guest_user?
      redirect_to recipe_path(params[:recipe_id]), alert: "自炊を記録するにはアカウント登録が必要です"
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
      goal = current_user.goals.find_by(target_month: Time.current.beginning_of_month)
      
      if goal && goal.achieved_at.nil?
        monthly_savings = current_user.cooking_records
                                    .where(cooked_at: Time.current.all_month)
                                    .sum("convenience_cost - cooking_cost")

        if monthly_savings >= goal.target_amount
          goal.update(achieved_at: Time.current)
          flash[:achievement] = "🎉 おめでとうございます！今月の目標を達成しました！"
        end
      end

      redirect_to profile_path, notice: "自炊お疲れ様です！記録しました。"
    else
      redirect_to recipe_path(@recipe), alert: "記録に失敗しました。"
    end
  end
end