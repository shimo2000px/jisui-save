class NotificationSetting < ApplicationRecord
  belongs_to :user
  validates :send_time, presence: true, if: :enabled?
end
