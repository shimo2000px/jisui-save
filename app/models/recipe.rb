class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :convenience_food
  has_one_attached :image
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank
  after_initialize :set_default_is_public, if: :new_record?

  def total_cost
    recipe_ingredients.to_a.sum(&:total_price)
  end

  def savings_amount
    convenience_food.price - total_cost
  end

  private

  def set_default_is_public
    self.is_public ||= false
  end
end
