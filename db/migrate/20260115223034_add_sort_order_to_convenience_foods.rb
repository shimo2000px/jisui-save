class AddSortOrderToConvenienceFoods < ActiveRecord::Migration[7.2]
  def change
    add_column :convenience_foods, :sort_order, :integer
  end
end
