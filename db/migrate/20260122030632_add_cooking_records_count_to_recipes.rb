class AddCookingRecordsCountToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :cooking_records_count, :integer, default: 0, null: false
  end
end
