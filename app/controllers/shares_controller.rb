class SharesController < ApplicationController
  skip_before_action :require_login, only: [ :show ]

  def show
    @user = User.find_by!(share_uid: params[:id])
    @user_name = @user.name

    start_of_month = Time.current.beginning_of_month
    today = Date.current

    @monthly_records = @user.cooking_records.where(cooked_at: start_of_month..Time.current.end_of_day)
    @monthly_savings = @monthly_records.sum("convenience_cost - cooking_cost")
    @cooking_count = @monthly_records.count

    daily_data = @user.cooking_records
                        .where(cooked_at: start_of_month..Time.current.end_of_day)
                        .group("DATE(cooked_at AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Tokyo')")
                        .sum("convenience_cost - cooking_cost")
                        .transform_keys(&:to_s)

    @chart_labels = (start_of_month.to_date..today).map(&:to_s)

    cumulative_sum = 0
    @chart_values = @chart_labels.map do |date|
      cumulative_sum += (daily_data[date] || 0)
      cumulative_sum
    end
  end
end
