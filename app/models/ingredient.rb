class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  def total_price
    if custom_price.present?
      custom_price
    else
      (ingredient.price_per_gram * amount_gram).round
    end
  end
end
