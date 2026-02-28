class User < ApplicationRecord
  has_one_attached :avatar
  has_one :notification_setting, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :cooking_records, dependent: :destroy
  has_many :goals, dependent: :destroy
  before_create :set_share_uid

  validates :name, presence: true

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  validates :share_uid, uniqueness: true, allow_nil: true

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

  def savings_for_month(date)
  cooking_records.where(cooked_at: date.all_month).sum("convenience_cost - cooking_cost")
  end

  def count_for_month(date)
    cooking_records.where(cooked_at: date.all_month).count
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

  def set_share_uid
    self.share_uid = SecureRandom.alphanumeric(10)
  end

  after_create :prepare_notification_setting

  private

  def prepare_notification_setting
    create_notification_setting
  end

  def self.find_or_create_from_auth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.name = auth.info.name
    user.line_user_id = auth.uid if auth.provider == "line"
    user.save
    user
  end
end
