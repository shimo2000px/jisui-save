class CookingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, optional: true
  belongs_to :recipe, counter_cache: true
  after_save :update_user_goal
  after_destroy :update_user_goal

  private

  def update_user_goal
    goal = user.goals.find_by(target_month: cooked_at.beginning_of_month)
    goal.update_achievement_status if goal
  end
end
