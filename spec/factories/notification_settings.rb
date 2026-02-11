FactoryBot.define do
  factory :notification_setting do
    association :user
    enabled { false }

    trait :enabled do
      enabled { true }
      send_time { "08:00" } 
    end
  end
end