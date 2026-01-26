class ProfilesController < ApplicationController
  def show
    if guest_user?
      redirect_to recipes_path, alert: "プロフィール機能はアカウント登録が必要です"
      return
    end

    @user = current_user
    @recipe = Recipe.new

    @goal = @user.goals.find_by(target_month: Time.current.beginning_of_month)

    @current_goal = @user.goals.find_by(target_month: Date.current.beginning_of_month)

    @monthly_stats = @user.monthly_cooking_stats

    daily_data = @user.cooking_records
                    .where(cooked_at: 30.days.ago.beginning_of_day..Time.current.end_of_day)
                    .group("DATE(cooked_at)")
                    .sum("convenience_cost - cooking_cost")
                    .transform_keys(&:to_s)

    @chart_labels = (30.days.ago.to_date..Date.current).map(&:to_s)

    cumulative_sum = 0
    @chart_values = @chart_labels.map do |date|
      cumulative_sum += (daily_data[date] || 0)
      cumulative_sum
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "退会しました"
  end

  private

  def set_user
      @current_user ||= User.find_by(id: session[:user_id])
      @user = @current_user
  end

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
end
