class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  def total_price
    return 0 if ingredient.nil?

    custom_price || ((ingredient&.price_per_gram || 0) * (amount_gram || 0)).round
  end
end
