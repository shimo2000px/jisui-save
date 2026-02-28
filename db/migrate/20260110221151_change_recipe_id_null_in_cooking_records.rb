class ChangeRecipeIdNullInCookingRecords < ActiveRecord::Migration[7.2]
  def change
    change_column_null :cooking_records, :recipe_id, true
  end
end
