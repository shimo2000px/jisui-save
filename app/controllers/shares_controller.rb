class SharesController < ApplicationController
  skip_before_action :require_login, only: [ :show ]

  def show
    @user = User.find_by!(share_uid: params[:id])

    @user_name = @user.name
    @monthly_records = @user.cooking_records.where(cooked_at: Time.current.all_month)
    @monthly_savings = @monthly_records.sum("convenience_cost - cooking_cost")
    @cooking_count = @monthly_records.count
    @user_name = @user.name
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
end
