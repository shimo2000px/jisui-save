FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "材料#{n}" }
    price_per_gram { 0 }
  end
end
