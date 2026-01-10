class User < ApplicationRecord
  has_one_attached :avatar

  has_many :cooking_records, dependent: :destroy

  # 累計節約額を計算（コンビニ費用 - 自炊費用）
  def total_savings
    cooking_records.sum("convenience_cost - cooking_cost")
  end

  # 今月の節約額
  def savings_this_month
    cooking_records.where(cooked_at: Time.current.all_month).sum("convenience_cost - cooking_cost")
  end

  # 今月の自炊回数
  def count_this_month
    cooking_records.where(cooked_at: Time.current.all_month).count
  end
end
