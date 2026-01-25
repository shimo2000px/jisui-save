class GoalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @goal = current_user.goals.find_by(target_month: Time.current.beginning_of_month)
    redirect_to edit_goal_path(@goal) if @goal

    @goal = current_user.goals.build
  end

  def create
    @goal = current_user.goals.build(goal_params)
    @goal.target_month = Time.current.beginning_of_month

    if @goal.save
      redirect_to profile_path, notice: "今月の目標を設定しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @goal = current_user.goals.find(params[:id])
  end

  def update
    @goal = current_user.goals.find(params[:id])
    if @goal.update(goal_params)
      redirect_to profile_path, notice: "目標を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:target_amount, :target_times)
  end
end