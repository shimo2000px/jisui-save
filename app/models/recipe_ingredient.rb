class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  def total_price
    custom_price || (ingredient.price_per_gram * amount_gram).round
  end
end
