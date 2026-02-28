class Goal < ApplicationRecord
  belongs_to :user

  def update_achievement_status
    actual_savings = user.savings_for_month(target_month)
    actual_count = user.count_for_month(target_month)

    if actual_savings >= target_amount && actual_count >= target_times
      update(achieved_at: Time.current) if achieved_at.nil?
    else
      update(achieved_at: nil) if achieved_at.present?
    end
  end
end
