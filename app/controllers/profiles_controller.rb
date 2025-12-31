class ProfilesController < ApplicationController
  def show
    @user = current_user
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

  def user_params
    # 名前とアイコン画像のみ許可
    params.require(:user).permit(:name, :avatar)
  end
end
