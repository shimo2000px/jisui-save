FactoryBot.define do
  factory :recipe do
    title { "めんつゆで作る！親子丼" }
    association :user
    association :convenience_food

    after(:build) do |recipe|
      if recipe.recipe_ingredients.empty?
        recipe.recipe_ingredients << build(:recipe_ingredient, recipe: recipe)
      end
    end
  end
end
