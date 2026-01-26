class GoalsController < ApplicationController
  before_action :require_login
  before_action :set_goal, only: [ :edit, :update, :destroy ]

  def index
    @user = current_user
    @goals = current_user.goals.order(target_month: :desc)
  end

  def create
    @goal = current_user.goals.build(goal_params)
    @goal.target_month = Time.current.beginning_of_month

    if @goal.save
      redirect_to profile_path, notice: "目標を設定しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @goal.update(goal_params)
      redirect_to profile_path, notice: "目標を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy
    redirect_to profile_path, notice: "目標を削除しました"
  end

  private

  def set_goal
    if params[:id] == "current"
      @goal = current_user.goals.find_or_initialize_by(target_month: Time.current.beginning_of_month)
    else
      @goal = current_user.goals.find(params[:id])
    end
  end

  def goal_params
    params.require(:goal).permit(:target_amount, :target_times)
  end
end
