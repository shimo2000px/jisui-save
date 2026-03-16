class CookingRecordsController < ApplicationController
  before_action :require_login

  def index
    # ユーザーの料理記録をレシピごとに集計して取得。これでDBからの取得は1回で済む。
    @cooking_records = current_user.cooking_records
                                  .includes(:recipe)
                                  .select(
                                    "MAX(id) as id",
                                    "recipe_id",
                                    "COUNT(*) as count",
                                    "MAX(cooked_at) as latest_cooked_at",
                                    "SUM(convenience_cost) as total_convenience_cost", # 合計比較額
                                    "SUM(cooking_cost) as total_cooking_cost"          # 合計自炊費
                                  )
                                  .group(:recipe_id)
                                  .order("latest_cooked_at DESC")
                                  .page(params[:page])
  end

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

        # 目標額を超えたらフラッシュメッセージ
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
