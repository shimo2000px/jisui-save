class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :convenience_food
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  def total_cost
    recipe_ingredients.to_a.sum(&:total_price)
  end

  def savings_amount
    convenience_food.price - total_cost
  end
end
