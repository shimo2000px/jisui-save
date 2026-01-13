class AddCategoryToConvenienceFoods < ActiveRecord::Migration[7.2]
  def change
    add_column :convenience_foods, :category, :string
  end
end
