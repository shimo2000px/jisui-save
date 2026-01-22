class CookingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, optional: true
  belongs_to :recipe, counter_cache: true
end
