FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { Faker::Internet.unique.email }
    provider { "google_oauth2" } 
    uid { SecureRandom.uuid }

    trait :guest do
      name { "ゲストユーザー" }
      email { "guest@example.com" }
      provider { "guest" }
      uid { "guest" }
    end

    trait :line do
      provider { "line" }
      line_user_id { SecureRandom.uuid }
    end
  end
end