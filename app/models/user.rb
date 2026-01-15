class User < ApplicationRecord
  has_one_attached :avatar
  has_many :recipes, dependent: :destroy
  has_many :cooking_records, dependent: :destroy

  def total_savings
    cooking_records.sum("convenience_cost - cooking_cost")
  end

  def total_cooking_count
  cooking_records.count
  end

  def cooking_rank
    count = total_cooking_count
    case count
    when 0..4    then { name: "自炊ビギナー", icon: "🌱" }
    when 5..14   then { name: "自炊ルーキー", icon: "🍳" }
    when 15..29  then { name: "自炊中級者", icon: "🔪" }
    when 30..49  then { name: "自炊職人", icon: "🔥" }
    else              { name: "自炊マスター", icon: "👑" }
    end
  end

  def savings_this_month
    cooking_records.where(cooked_at: Time.current.all_month).sum("convenience_cost - cooking_cost")
  end

  def count_this_month
    cooking_records.where(cooked_at: Time.current.all_month).count
  end

  def monthly_cooking_stats
    cooking_records
      .select(
        "DATE_TRUNC('month', cooked_at) AS month",
        "COUNT(*) AS count",
        "SUM(convenience_cost - cooking_cost) AS savings"
      )
      .group("month")
      .order("month DESC")
  end
end
