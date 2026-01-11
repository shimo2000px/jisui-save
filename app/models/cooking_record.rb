class CookingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, optional: true
end
