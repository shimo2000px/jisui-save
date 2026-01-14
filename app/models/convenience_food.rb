class ConvenienceFood < ApplicationRecord
  has_many :recipes, dependent: :restrict_with_error
end
