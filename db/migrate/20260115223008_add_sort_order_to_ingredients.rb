class AddSortOrderToIngredients < ActiveRecord::Migration[7.2]
  def change
    add_column :ingredients, :sort_order, :integer
  end
end
