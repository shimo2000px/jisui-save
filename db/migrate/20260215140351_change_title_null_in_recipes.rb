class ChangeTitleNullInRecipes < ActiveRecord::Migration[7.2]
  def change
    change_column_null :recipes, :title, false
  end
end
