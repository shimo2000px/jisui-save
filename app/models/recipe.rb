class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :convenience_food
  has_one_attached :image
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :cooking_records, dependent: :nullify
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank
  after_initialize :set_default_is_public, if: :new_record?
  validates :recipe_ingredients, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["title", "description", "cooking_records_count", "created_at"]
  end

  def total_cost
    recipe_ingredients.to_a.sum(&:total_price) || 0
  end

  def savings_amount
    return 0 if convenience_food.nil?

    (convenience_food.price || 0) - (total_cost || 0)
  end

  private

  def set_default_is_public
    self.is_public = false if self.is_public.nil?
  end
end
