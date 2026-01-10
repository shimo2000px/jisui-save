class ProfilesController < ApplicationController
  def show
    @user = current_user
    @monthly_stats = @user.monthly_cooking_stats
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

  private

  def set_user
      @current_user ||= User.find_by(id: session[:user_id])
      @user = @current_user
  end

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
end
